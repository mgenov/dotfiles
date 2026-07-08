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

    -- Function text objects: cif clears the body, daf deletes the whole func.
    vim.keymap.set({ 'x', 'o' }, 'if', function() select('@function.inner', 'textobjects') end, { desc = 'inside function' })
    vim.keymap.set({ 'x', 'o' }, 'af', function() select('@function.outer', 'textobjects') end, { desc = 'around function' })

    -- Jump between arguments / elements without leaving normal mode: ]a / [a.
    local move = require('nvim-treesitter-textobjects.move')
    vim.keymap.set({ 'n', 'x', 'o' }, ']a', function() move.goto_next_start('@parameter.inner', 'textobjects') end, { desc = 'next argument' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[a', function() move.goto_previous_start('@parameter.inner', 'textobjects') end, { desc = 'prev argument' })

    -- Jump between functions: ]f / [f.
    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer', 'textobjects') end, { desc = 'next function' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'prev function' })

    -- Swap the argument under the cursor with the next / previous one: ]A / [A.
    local swap = require('nvim-treesitter-textobjects.swap')
    vim.keymap.set('n', ']A', function() swap.swap_next('@parameter.inner') end, { desc = 'swap arg with next' })
    vim.keymap.set('n', '[A', function() swap.swap_previous('@parameter.inner') end, { desc = 'swap arg with prev' })
  end,
}
