-- Compile the surrounding Bazel package(s) into the quickfix list.
-- For plain :make, %:h expands to the current file's directory relative to
-- nvim's cwd, so from the repo root this builds e.g.
-- apps/x/services/y/go/internal/handlers/... — narrow analysis + warm
-- cache keeps it fast, unlike a whole-repo //... build.
vim.opt_local.makeprg = [[bazel build --color=no --curses=no %:h/...]]

-- rules_go prints compiler errors as `path/file.go:12:6: message` relative
-- to the workspace root, which makes the entries jumpable. Bazel's own
-- `ERROR: /abs/path/BUILD.bazel:...: GoCompilePkg failed` wrapper must be
-- ignored explicitly and first — %f would otherwise greedily swallow the
-- `ERROR: ` prefix into the filename. Remaining INFO/progress lines fall
-- through to the final catch-all and are dropped.
vim.opt_local.errorformat = table.concat({
  [[%-GERROR: %.%#]],
  [[%f:%l:%c: %m]],
  [[%f:%l: %m]],
  [[%-G%.%#]],
}, ',')

-- Returns the Bazel workspace root and the current file's package path
-- relative to it. %:h can't be used for the package: a buffer opened by an
-- absolute path (pickers, jumps) keeps that absolute name, and bazel rejects
-- package names starting with '/'.
local function bazel_package()
  local package_dir = vim.fn.expand '%:p:h'
  local root = vim.fs.root(package_dir, { 'MODULE.bazel', 'WORKSPACE', 'WORKSPACE.bazel' })
  if not root then
    error('not inside a Bazel workspace: ' .. package_dir, 0)
  end
  local rel = vim.fs.relpath(root, package_dir)
  -- Absolute label, so it reads the same as one typed by hand; a file at the
  -- workspace root is the root package, `//...`.
  return root, '//' .. (rel == '.' and '' or rel .. '/') .. '...'
end

local function bazel_quickfix(subcommand)
  local makeprg = vim.opt_local.makeprg:get()
  local package_dir = vim.fn.expand '%:p:h'
  local command_cwd = vim.fs.normalize(vim.fn.getcwd())
  local _, package = bazel_package()
  vim.opt_local.makeprg = ('bazel %s --color=no --curses=no %s'):format(subcommand, package)

  local ok, err = pcall(vim.cmd, 'silent make!')
  vim.opt_local.makeprg = makeprg

  if not ok then
    error(err)
  end

  if subcommand == 'test' then
    local qf = vim.fn.getqflist { items = 0, idx = 0 }
    local changed = false

    for _, item in ipairs(qf.items) do
      local filename = item.bufnr > 0 and vim.api.nvim_buf_get_name(item.bufnr) or ''

      -- `go test` reports source files relative to the package under test.
      -- :make resolves them from nvim's cwd, which can create an empty buffer
      -- at the workspace root instead of opening the real test file.
      if filename ~= '' and vim.fn.filereadable(filename) == 0 then
        local cwd_prefix = command_cwd .. '/'
        local relative = vim.startswith(filename, cwd_prefix) and filename:sub(#cwd_prefix + 1) or nil
        local candidate = relative and vim.fs.joinpath(package_dir, relative) or nil

        if not candidate or vim.fn.filereadable(candidate) == 0 then
          local matches = vim.fs.find(vim.fs.basename(filename), {
            path = package_dir,
            type = 'file',
            limit = 2,
          })
          candidate = #matches == 1 and matches[1] or nil
        end

        if candidate and vim.fn.filereadable(candidate) == 1 then
          item.bufnr = vim.fn.bufadd(candidate)
          changed = true
        end
      end
    end

    if changed then
      vim.fn.setqflist({}, 'r', { items = qf.items, idx = qf.idx })
    end
  end

  -- silent external commands can leave artifacts in terminal nvim
  vim.cmd 'redraw!'
  -- opens quickfix only when there are entries, closes it when the command is clean
  vim.cmd 'cwindow'
end

-- Flags that cut bazel's output down to errors only, so the result fits a
-- small split: no progress, INFO or WARNING lines, and no "Target ... up to
-- date" listing. A clean build prints nothing; buildterm adds the OK line.
local quiet_flags = table.concat({
  '--curses=no',
  '--color=yes',
  '--noshow_progress',
  '--ui_event_filters=-info,-debug,-warning',
  '--show_result=0',
  '--noannounce_rc',
}, ' ')

-- .bazelrc sets --test_output=all for tests; errors-only keeps passing tests
-- silent and shows the log of the failing ones.
local quiet_test_flags = '--test_output=errors --test_summary=terse'

local function bazel_term(subcommand, extra)
  local root, package = bazel_package()
  -- The echoed label leaves out quiet_flags: they only change what is
  -- printed, and without them the line fits the panel and can be re-run as is
  -- from the workspace root.
  require('buildterm').run(('bazel %s %s %s %s'):format(subcommand, quiet_flags, extra or '', package), {
    label = ('bazel %s %s%s'):format(subcommand, extra and extra .. ' ' or '', package),
    cwd = root,
  })
end

vim.keymap.set('n', '<leader>bb', function()
  bazel_term 'build'
end, { buffer = true, desc = 'Bazel-build current package (terminal)' })

vim.keymap.set('n', '<leader>bt', function()
  bazel_term('test', quiet_test_flags)
end, { buffer = true, desc = 'Bazel-test current package (terminal)' })

vim.keymap.set('n', '<leader>bB', function()
  bazel_quickfix 'build'
end, { buffer = true, desc = 'Bazel-build current package into quickfix' })

vim.keymap.set('n', '<leader>bT', function()
  bazel_quickfix 'test'
end, { buffer = true, desc = 'Bazel-test current package into quickfix' })
