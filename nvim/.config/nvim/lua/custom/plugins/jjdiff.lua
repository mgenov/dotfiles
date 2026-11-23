-- Telescope pickers over jj diffs wider than the working-copy change.
--
-- The working-copy diff itself is `<leader>gs` in init.lua: that mapping
-- falls back to git status outside a Jujutsu repository, so it belongs with
-- the VCS-agnostic keys rather than with these jj-only ones.
--
-- Every view is a revset, and `jj diff -r` totals the diff over a revset with
-- several heads, so each one also works when `@` sits on a megamerge.
local function diff(revset)
  return function()
    require('telescope').extensions.jj.diff { revision = revset }
  end
end

vim.keymap.set('n', '<leader>jp', diff '@-', { desc = 'jj diff: [P]revious change' })
-- What the previous change would contain after `jj squash`.
vim.keymap.set('n', '<leader>jb', diff '@-::@', { desc = 'jj diff: previous + current ([B]oth)' })
-- Everything a reviewer would see: all changes not yet on trunk.
vim.keymap.set('n', '<leader>jt', diff 'trunk()..@', { desc = 'jj diff: stack since [T]runk' })

return {}
