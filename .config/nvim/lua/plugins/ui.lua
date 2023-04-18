local utils = require("utils")

return {
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Gitsigns",
    opts = {
      -- See `:help gitsigns.txt`
      signs = utils.icons.gitsigns,
      preview_config = {
        border = "rounded",
        style = "minimal",
      },
      current_line_blame_formatter = "<author> (<author_time:%R>)",
    },
    -- stylua: ignore
    keys = {
      { "<leader>gb",  function() require("gitsigns").blame_line{full=true} end,       desc = "[g]it [b]lame" },
      { "<leader>tgb", function() require("gitsigns").toggle_current_line_blame() end, desc = "[t]oggle [g]it [b]lame" },
      { "<leader>gd",  function() require("gitsigns").preview_hunk() end,              desc = "[g]it [d]iff" },
      { "[c",          function() require("gitsigns").prev_hunk() end,                 desc = "Next git hunk" },
      { "]c",          function() require("gitsigns").next_hunk() end,                 desc = "Previous git hunk" },
      { "<leader>ghu", ":Gitsigns reset_hunk<cr>",       mode = { "n", "v" },          desc = "Reset git stage hunk" },
      { "ih",          ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" },          desc = "GitSigns Select Hunk" },
    },
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" }, -- 
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          globalstatus = true,
        },
        sections = {
          -- left
          lualine_a = { "mode" },
          lualine_b = {
            {
              "b:gitsigns_head",
              icon = "",
              on_click = function()
                require("telescope.builtin").git_branches()
              end,
              cond = utils.is_wide_term,
            },
            {
              "diff",
              source = utils.diff_source,
              on_click = function(_)
                local fug_buf = vim.fn.bufname("fugitive:///*/.git//$")
                if vim.fn.buflisted(fug_buf) ~= 0 then
                  vim.cmd.bdelete(fug_buf)
                else
                  vim.cmd.Git()
                end
              end,
            },
            {
              "diagnostics",
              on_click = function(_)
                vim.cmd.TroubleToggle("document_diagnostics")
              end,
            },
          },
          lualine_c = {
            {
              "filename",
              on_click = function(_)
                if
                  vim.tbl_contains(
                    { "gitcommit", "gitrebase", "alpha", "help", "TelescopePrompt", "vim", "" },
                    vim.bo.filetype
                  )
                then
                  return
                end
                utils.copy_relative_path()
              end,
            },
          },
          -- right
          lualine_x = {
            {
              "b:gitsigns_blame_line",
              icon = "",
              cond = utils.is_wide_term,
            },
            {
              utils.lsp_progress,
              on_click = function()
                vim.cmd.LspInfo()
              end,
            },
            {
              utils.copilot_indicator,
              on_click = function(_)
                vim.ui.input({
                  prompt = "Disable Copilot? (Re enable with ':Copilot enable' later)\nType y/yes to confirm: ",
                }, function(input)
                  if input == "y" or input == "yes" then
                    vim.cmd([[Copilot disable]])
                  end
                end)
              end,
            },
            {
              -- python env
              function()
                -- local venv = get_venv("VIRTUAL_ENV") or "System"
                local venv = utils.parse_venv(os.getenv("VIRTUAL_ENV"))
                  or utils.parse_venv(utils.pyright_python())
                  or "System"
                return "󰌠 " .. venv
              end,
              cond = function()
                return vim.bo.filetype == "python"
              end,
              on_click = function(_)
                vim.ui.input({
                  prompt = "Enter python venv path: ",
                  default = utils.find_venv_path(),
                  completion = "file",
                }, function(input)
                  if input then
                    vim.cmd([[PyrightSetPythonPath ]] .. input)
                  end
                end)
              end,
            },
            {
              function()
                return " " .. vim.o.channel
              end,
              cond = function()
                return vim.o.buftype == "terminal"
              end,
            },
            {
              function()
                return "Preview"
              end,
              cond = function()
                return vim.o.filetype == "markdown" and vim.fn.exists(":PreviewOpen") == 2
              end,
              on_click = function(_)
                local peek = require("peek")
                if peek.is_open() then
                  peek.close()
                else
                  peek.open()
                end
              end,
            },
            utils.statusline_indent_guide,
            { "encoding" },
            { "fileformat", icons_enabled = true, symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
            { "filetype", icons_enabled = false },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filetype", icon_only = true, color = { bg = "none" } },
            {
              "filename",
              path = 2,
              fmt = function(output)
                if
                  require("lazy.core.config").plugins["nvim-navic"]._.loaded
                  and require("nvim-navic").is_available()
                then
                  if require("nvim-navic").get_location() ~= "" then
                    return require("nvim-navic").get_location()
                  end
                end
                return output
              end,
              color = { bg = "none" },
              on_click = function(_)
                if
                  vim.tbl_contains(
                    { "gitcommit", "gitrebase", "alpha", "help", "TelescopePrompt", "vim", "" },
                    vim.bo.filetype
                  )
                then
                  return
                end
                utils.copy_absolute_path()
              end,
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filetype", icon_only = true, color = { bg = "none" } },
            { "filename", path = 4, separator = { left = "", right = "" }, color = { bg = "none" } },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  -- statuscolumn
  {
    "luukvbaal/statuscol.nvim",
    -- event = "VeryLazy",
    opts = function()
      local builtin = require("statuscol.builtin")
      local is_active_window = function(args)
        return vim.api.nvim_get_current_win() == args.win
      end
      return {
        setopt = true,
        relculright = false,
        ft_ignore = { "terminal", "help", "vim", "Trouble", "lazy", "nofile" },
        bt_ignore = { "terminal", "quickfix", "lazy", "nofile" },
        segments = {
          { --[[ Fold Column ]]
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
            condition = { is_active_window },
          },
          { --[[ diagnostic column ]]
            sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa",
          },
          { --[[ number ]]
            text = { builtin.lnumfunc },
          },
          { --[[ git ]]
            sign = { name = { "GitSigns" }, maxwidth = 1, colwidth = 1, auto = false },
            click = "v:lua.ScSa",
          },
        },
        clickhandlers = {
          FoldOther = false, -- Disable builtin clickhandler
        },
      }
    end,
  },

  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    opts = function()
      return {
        separator = " > ",
        highlight = true,
        depth_limit = 5,
        depth_limit_indicator = "..",
        lsp = { auto_attach = true },
        icons = utils.icons.navic,
      }
    end,
  },
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("noice").setup({})
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     -- "rcarriga/nvim-notify",
  --   },
  -- },
}
