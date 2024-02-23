return {
  -- Git related plugins
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "[g]it [s]tatus" },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Undotree
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "[u]ndo tree" },
    },
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        priority = 50,
      },
      scope = { enabled = false },
      exclude = {filetypes = { "help", "Trouble", "lazy" }},
      whitespace = { remove_blankline_trail = true },
    },
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- auto pair brackets
  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "echasnovski/mini.map",
    config = function()
      local map = require("mini.map")
      map.setup({
        symbols = {
          encode = require("mini.map").gen_encode_symbols.dot("4x2"),
          scroll_line = "┃",
          scroll_view = "│",
        },
        integrations = {
          require("mini.map").gen_integration.builtin_search(),
          require("mini.map").gen_integration.diagnostic(),
          -- require("mini.map").gen_integration.gitsigns(),
        },
        window = {
          show_integration_count = false,
          width = 10,
          winblend = 90,
        },
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader>mm", function() require("mini.map").toggle() end, desc = "[M]ini[M]ap" },
      { "<leader>mf", function() require("mini.map").toggle_focus() end, desc = "[M]inimap [F]ocus" },
    },
  },
  -- folds
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    -- stylua: ignore
    init = function()
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
    end,
    config = function()
      require("ufo").setup({
        open_fold_hl_timeout = 400,
        close_fold_kinds = {},
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ("  %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "Fold" })
          return newVirtText
        end,
        enable_get_fold_virt_text = false,
        preview = {}
      })
    end,
  },
}
