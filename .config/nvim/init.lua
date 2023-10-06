if vim.loader then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set options/remaps in 'config'
require("config")

-- Install plugins in `plugins`
require("lazy").setup("plugins", {
  install = { colorscheme = { "nord" } },
  defaults = { lazy = true },
})
