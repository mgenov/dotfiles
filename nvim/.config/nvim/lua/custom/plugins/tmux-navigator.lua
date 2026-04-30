-- Seamless C-h/j/k/l navigation between nvim splits and tmux panes.
-- Pairs with the is_vim guard in tmux.conf — pressing C-h with no nvim split
-- to the left falls through to `tmux select-pane -L`, and vice versa.
return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft', 'TmuxNavigateDown',
    'TmuxNavigateUp',   'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>',  desc = 'Window/pane left' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>',  desc = 'Window/pane down' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>',    desc = 'Window/pane up' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Window/pane right' },
  },
}
