return {
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        "<leader>q",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        silent = true,
        noremap = true,
        desc = "Open diagnostics list",
      },
      {
        "<leader>wq",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        silent = true,
        noremap = true,
        desc = "Open [w]orkspace diagnostics",
      },
    },
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
}
