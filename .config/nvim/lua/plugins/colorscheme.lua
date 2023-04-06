return {
  {
    -- Color Scheme
    -- 'AlexvZyl/nordic.nvim',
    'shaunsingh/nord.nvim',
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_italic = false
      vim.cmd.colorscheme 'nord'
    end,
  },
  --[[ {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
  } , ]]
}
