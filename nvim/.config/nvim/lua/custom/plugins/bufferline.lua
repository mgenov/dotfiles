-- bufferline.nvim — open buffers shown as tabs along the top of the screen.
--
-- have_nerd_font is off in this config, so file-type icons and the default
-- Nerd Font glyphs are swapped for plain characters. Close buttons are hidden:
-- buffers are closed from the keyboard, not by clicking.
return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VimEnter',
  opts = {
    options = {
      show_buffer_icons = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      modified_icon = '●',
      left_trunc_marker = '<',
      right_trunc_marker = '>',
      -- Position in the bar, the N that `:BufferLineGoToBuffer N` jumps to.
      numbers = 'ordinal',
      diagnostics = 'nvim_lsp',
    },
  },
  keys = {
    -- Replace Neovim's default [b / ]b so cycling follows the order shown in
    -- the bar, which can differ from buffer numbers after moving tabs.
    { '[b', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
    { ']b', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '[B', '<cmd>BufferLineMovePrev<CR>', desc = 'Move buffer left' },
    { ']B', '<cmd>BufferLineMoveNext<CR>', desc = 'Move buffer right' },
    { 'gb', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
    { 'gB', '<cmd>BufferLinePickClose<CR>', desc = 'Pick buffer to close' },
  },
}
