return {
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "[B]uffer [D]elete " },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "[B]uffer [D]elete (Force)" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
  },
  -- markdown preview
  {
    "toppair/peek.nvim",
    ft = "markdown",
    build = "deno task --quiet build:fast",
    opts = { theme = "light", app = "browser" },
    config = function(_, opts)
      require("peek").setup(opts)
      vim.api.nvim_create_user_command("PreviewOpen", require("peek").open, { desc = "Open Markdown Preview" })
      vim.api.nvim_create_user_command("PreviewClose", require("peek").close, { desc = "Close Markdown Preview" })
    end,
  },
}
