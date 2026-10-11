-- Runs a build command in a short terminal split at the bottom of the screen
-- and prints a coloured OK/FAILED line at the end, so the result is readable
-- even when the command itself prints nothing on success (quiet bazel).
-- Pressing q in the output window closes it and returns to the code.
local M = {}

local height = 12

-- opts.label, when given, is echoed as a command line above the output, so
-- callers can show a readable form of a cmd that carries long noise-reducing
-- flags. Without it only the command's own output is shown.
-- opts.status = false drops the OK/FAILED line, for tools whose own output
-- already makes the result obvious.
-- opts.cwd runs the command from that directory instead of nvim's cwd.
function M.run(cmd, opts)
  opts = opts or {}
  local header = opts.label and ([[printf '\033[2m$ %%s\033[0m\n' %s; ]]):format(vim.fn.shellescape(opts.label)) or ''
  -- `rc`, not `status`: the command runs in 'shell', and zsh reserves $status.
  local footer = opts.status == false and ''
    or [[ && printf '\n\033[32m✓ OK\033[0m\n' || { rc=$?; printf '\n\033[31m✗ FAILED\033[0m\n'; exit $rc; }]]
  local wrapped = header .. cmd .. footer
  -- jobstart turns the current buffer into the terminal, so the split must
  -- hold a fresh empty buffer rather than the source file.
  vim.cmd(('botright %dnew'):format(height))
  vim.fn.jobstart(wrapped, { term = true, cwd = opts.cwd })
  -- Closing the window would otherwise leave a hidden term:// buffer behind
  -- for every build. Wiping also stops a build that is still running.
  vim.bo.bufhidden = 'wipe'
  vim.cmd 'normal! G'
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = true, desc = 'Close build output' })
end

return M
