require('kanagawa').setup({
  transparent = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
        syn = {
            special1 = "#957FB8", -- oniViolet color in the palette,
        }
      }
    }
  },
})


vim.cmd.colorscheme('kanagawa')
require('lualine').setup({
  options = {
    theme = 'kanagawa',
  },
})
vim.treesitter.language.register('htmldjango', 'html')
