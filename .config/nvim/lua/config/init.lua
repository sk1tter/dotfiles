require("config.set")
require("config.remap")
require("config.autocmds")

if vim.g.neovide then
  require("config.neovide")
end
