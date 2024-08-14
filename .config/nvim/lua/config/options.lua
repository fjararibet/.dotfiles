vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable relative line numbering
vim.wo.relativenumber = true

-- status line
vim.o.laststatus = 2

-- Number width. NO NECK PAIN
local min_width = 4
local max_width = 16
local flip_nuw = function()
  if vim.wo.numberwidth == max_width then
    vim.wo.numberwidth = min_width
  else
    vim.wo.numberwidth = max_width
  end
end
vim.wo.numberwidth = min_width
vim.keymap.set('n', '<leader>z', flip_nuw, { silent = true, desc = 'Make file e[x]ecutable' })
-- Enable mouse mode
vim.o.mouse = 'a'

-- Smart indent
vim.o.smartindent = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Prime recommendation
vim.o.scrolloff = 8
vim.o.guicursor = ""
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 0

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
