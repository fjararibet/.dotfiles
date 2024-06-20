return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds path completion
      'hrsh7th/cmp-path',

      -- Completes with word from buffer
      'hrsh7th/cmp-buffer',
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

    },
  },
  -- {
  --   "Jezda1337/nvim-html-css",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-lua/plenary.nvim"
  --   },
  --   config = function()
  --     require("html-css"):setup()
  --   end
  -- }
}
