-- Yazi file manager inside nvim, mirroring helix's <C-e> binding.
return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<C-e>', '<cmd>Yazi<cr>', desc = 'Yazi (current file)' },
    { '<leader>yc', '<cmd>Yazi cwd<cr>', desc = '[Y]azi at [c]wd' },
    { '<leader>yt', '<cmd>Yazi toggle<cr>', desc = '[Y]azi [t]oggle' },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
}
