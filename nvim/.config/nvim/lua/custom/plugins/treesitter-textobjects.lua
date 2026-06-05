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

    -- Argument / array-element text objects: cia/dia inside one arg, daa eats the comma too.
    vim.keymap.set({ 'x', 'o' }, 'ia', function() select('@parameter.inner', 'textobjects') end, { desc = 'inside argument' })
    vim.keymap.set({ 'x', 'o' }, 'aa', function() select('@parameter.outer', 'textobjects') end, { desc = 'around argument' })

    -- Jump between arguments / elements without leaving normal mode: ]a / [a.
    local move = require('nvim-treesitter-textobjects.move')
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', function() move.goto_next_start('@parameter.inner', 'textobjects') end, { desc = 'next argument' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[a', function() move.goto_previous_start('@parameter.inner', 'textobjects') end, { desc = 'prev argument' })
  end,
}
