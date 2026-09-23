-- Notes vault helpers: daily and concept notes created from the vault's own
-- templates. The only per-vault input is its path, so the commands and
-- keymaps work from any project, not only when nvim is started in the vault.
local M = {}

local function fill(template_path, subs)
  vim.cmd('0r ' .. vim.fn.fnameescape(template_path))
  for key, val in pairs(subs) do
    vim.cmd(string.format('silent! %%s/{{%s}}/%s/ge', key, val))
  end
  vim.cmd 'normal! G'
end

function M.setup(opts)
  local vault = vim.fs.normalize(opts.path)
  local group = vim.api.nvim_create_augroup('notes-vault', { clear = true })

  -- Daily file names are `YYYY-MM-DD[-Suffix].md`; the suffix, when present,
  -- becomes the note title instead of the date.
  vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = vault .. '/daily/*.md',
    callback = function()
      local fname = vim.fn.expand '%:t:r'
      local date, suffix = fname:match '^(%d%d%d%d%-%d%d%-%d%d)%-?(.*)$'
      if not date then
        date, suffix = fname, ''
      end
      fill(vault .. '/templates/daily.md', {
        date = date,
        title = suffix ~= '' and suffix or date,
      })
    end,
  })

  vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = vault .. '/concepts/*.md',
    callback = function()
      fill(vault .. '/templates/concept.md', {
        date = os.date '%Y-%m-%d',
        title = (vim.fn.expand('%:t:r'):gsub('-', ' ')),
      })
    end,
  })

  -- Both commands honour modifiers, so `:vert Daily` opens the note in a
  -- vertical split next to the current buffer.
  local function open(path, smods)
    vim.cmd { cmd = smods.vertical and 'split' or 'edit', args = { path }, mods = smods }
  end

  vim.api.nvim_create_user_command('Daily', function(o)
    local name = os.date '%Y-%m-%d'
    if o.args ~= '' then
      name = name .. '-' .. o.args
    end
    open(vault .. '/daily/' .. name .. '.md', o.smods)
  end, { nargs = '?', desc = "Open today's daily note" })

  vim.api.nvim_create_user_command('Concept', function(o)
    open(vault .. '/concepts/' .. o.args:gsub('%s+', '-') .. '.md', o.smods)
  end, { nargs = 1, desc = 'Open a concept note' })

  vim.keymap.set('n', '<leader>nd', '<cmd>vertical Daily<CR>', { desc = "[N]otes: today's [D]aily (vsplit)" })
  vim.keymap.set('n', '<leader>nc', ':vertical Concept ', { desc = '[N]otes: [C]oncept (vsplit)' })
end

return M
