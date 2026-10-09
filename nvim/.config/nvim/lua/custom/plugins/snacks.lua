-- snacks.nvim, enabled only for its GitHub integration (`gh`) and the picker
-- that drives it. Requires an authenticated `gh` CLI.
--
-- Telescope remains the main picker, so ui_select is off to leave
-- vim.ui.select to telescope-ui-select.
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    gh = {},
    picker = {
      ui_select = false,
    },
  },
  keys = {
    { '<leader>gi', function() Snacks.picker.gh_issue() end, desc = 'GitHub [I]ssues (open)' },
    { '<leader>gI', function() Snacks.picker.gh_issue { state = 'all' } end, desc = 'GitHub [I]ssues (all)' },
    { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'GitHub [P]ull requests (open)' },
    { '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, desc = 'GitHub [P]ull requests (all)' },
  },
}
