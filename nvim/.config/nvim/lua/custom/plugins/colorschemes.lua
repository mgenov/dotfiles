-- Candidate colorschemes kept installed for side-by-side comparison with the
-- active catppuccin (init.lua). All are lazy: lazy.nvim loads one the first
-- time `:colorscheme <name>` asks for it, so they cost nothing at startup.
-- <leader>tc opens a live-preview picker over them.
return {
  {
    'loctvl842/monokai-pro.nvim',
    lazy = true,
    -- Each filter is also exposed as its own colorscheme, e.g.
    -- `monokai-pro-spectrum`, so no default filter is forced here.
    opts = {},
  },
  {
    'sainnhe/sonokai',
    lazy = true,
    init = function()
      -- Read when the colorscheme loads; styles: default, atlantis,
      -- andromeda, shusia, maia, espresso.
      vim.g.sonokai_style = 'default'
    end,
  },
  {
    'savq/melange-nvim',
    lazy = true,
  },
  {
    -- Previous default, with the same settings it had there.
    'folke/tokyonight.nvim',
    lazy = true,
    opts = {
      style = 'moon',
      styles = { comments = { italic = false } },
    },
  },
  {
    -- Variants: kanagawa-wave, kanagawa-dragon, kanagawa-lotus (light).
    'rebelot/kanagawa.nvim',
    lazy = true,
    opts = { commentStyle = { italic = false } },
  },
  {
    -- Variants: rose-pine-main, rose-pine-moon, rose-pine-dawn (light).
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = true,
  },
}
