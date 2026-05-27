-- Harpoon (harpoon2): pin a small working set of files and jump to each by a fixed key.
-- ThePrimeagen's layout: <leader>a adds the current file, <leader>1-4 jump to slots 1-4.
-- <leader>m toggles the editable quick menu (reorder/remove there). Prime's own menu key
-- is <C-e>, but that's already our mini.files opener (init.lua), so the menu lives on <leader>m.
-- The list is per project (keyed by git root / cwd) and persisted, so each monorepo worktree
-- keeps its own set across restarts.
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function() require('harpoon'):setup() end,
  -- require() stays inside each callback so the plugin only loads on first keypress.
  keys = {
    { '<leader>a', function() require('harpoon'):list():add() end, desc = 'Harpoon [A]dd file' },
    {
      '<leader>m',
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon [M]enu',
    },
    { '<leader>1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon to file 1' },
    { '<leader>2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon to file 2' },
    { '<leader>3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon to file 3' },
    { '<leader>4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon to file 4' },

    -- Cycle prev/next through the list. NOTE: in a terminal these
    -- may be indistinguishable from <C-p>/<C-n> unless it speaks the Kitty keyboard
    -- protocol (Kitty/WezTerm/Ghostty/recent Alacritty). If they no-op, that's why.
    { '<C-S-P>', function() require('harpoon'):list():prev() end, desc = 'Harpoon prev file' },
    { '<C-S-N>', function() require('harpoon'):list():next() end, desc = 'Harpoon next file' },
  },
}
