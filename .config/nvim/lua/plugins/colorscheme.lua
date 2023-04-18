-- Color Scheme
return {
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    enabled = true,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_italic = false
      vim.g.nord_bold = true

      if not vim.g.neovide then
        vim.cmd.colorscheme("nord")
      end
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfox")
    end,
  },
  { -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      if vim.g.neovide then
        vim.cmd.colorscheme("onedark")
      end
    end,
  },
}
