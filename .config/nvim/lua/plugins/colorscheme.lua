-- Color Scheme
return {
  {
    "shaunsingh/nord.nvim",
    enabled = true,
    lazy = false,
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
    "rebelot/kanagawa.nvim",
    lazy = false,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
  },
  { -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      if vim.g.neovide then
        vim.cmd.colorscheme("onedark")
      end
    end,
  },
}
