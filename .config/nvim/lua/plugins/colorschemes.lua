return {
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true
    },
  },
  {
    'rose-pine/neovim',
    lazy = true,
    priority = 1000,
    name = 'rose-pine',
    opts = {
      transparent = true
    },
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            }
          }
        }
      },
    },
  }
}
