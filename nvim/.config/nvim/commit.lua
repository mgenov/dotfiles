-- Minimal config for `git commit` / interactive rebase.
-- Loads dracula colorscheme + treesitter highlighting for gitcommit/gitrebase,
-- skipping LSP, completion, telescope, lazy.nvim, etc. Used via:
--   export GIT_EDITOR="nvim -u $HOME/.config/nvim/commit.lua"

local lazy = vim.fn.stdpath 'data' .. '/lazy'
vim.opt.runtimepath:prepend(lazy .. '/dracula.nvim')
vim.opt.runtimepath:prepend(lazy .. '/nvim-treesitter/runtime')

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.spell = true
vim.opt.textwidth = 72
vim.opt.colorcolumn = '50,72'

vim.cmd.colorscheme 'dracula'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase' },
  callback = function() pcall(vim.treesitter.start) end,
})
