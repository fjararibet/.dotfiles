-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load every spec in `lua/custom/plugins/`
--    Editor options and keymaps live in `plugin/` (auto-sourced by Neovim),
--    filetype tweaks in `after/ftplugin/`.
require('lazy').setup({ import = 'custom.plugins' }, {
  change_detection = {
    notify = false,
  },
})

vim.cmd.colorscheme 'kanagawa'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
