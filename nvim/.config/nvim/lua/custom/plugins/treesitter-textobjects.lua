return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
    }
    local select = require('nvim-treesitter-textobjects.select').select_textobject
    vim.keymap.set({ 'x', 'o' }, 'aS', function() select('@assignment.outer', 'textobjects') end, { desc = 'around assignment/section' })
    vim.keymap.set({ 'x', 'o' }, 'iS', function() select('@assignment.inner', 'textobjects') end, { desc = 'inside assignment/section' })
  end,
}
