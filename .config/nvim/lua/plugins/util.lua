return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Useful plugin to show you pending keybinds.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
  },

  -- icons
  { "nvim-tree/nvim-web-devicons" },

  { "nvim-lua/plenary.nvim" },
}
