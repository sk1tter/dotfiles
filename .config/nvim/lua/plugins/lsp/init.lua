-- NOTE: This is where your plugins related to LSP can be installed.
-- The configuration is done below. Search for lspconfig to find it below.
return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "ray-x/lsp_signature.nvim",

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        "folke/neodev.nvim",
        config = function()
          -- Setup neovim lua configuration
          require("neodev").setup()
        end,
      },
    },
    opts = {
      -- diagnostics
      diagnositics = {
        virtual_text = false,
        -- virtual_text = {
        --   source = "always",
        --   -- prefix = "●",
        --   prefix = function(diagnostic)
        --     if diagnostic.severity == vim.diagnostic.severity.ERROR then
        --       return "" -- Nerd font icon for error
        --     elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        --       return "" -- Nerd font icon for warning
        --     elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        --       return "" -- Nerd font icon for info
        --     else
        --       return "" -- Nerd font icon for hint
        --     end
        --   end,
        -- },
        update_in_insert = false,
        severity_sort = true,
        underline = true,
        float = {
          border = "none",
          source = "always", -- Or "if_many"
        },
      },
      -- LSP Server Settings
      servers = {
        gopls = {
          gopls = {
            semanticTokens = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        pyright = {
          python = {
            venvPath = ".venv",
            analysis = {
              useLibraryCodeForTypes = true,
              stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs", -- downloaded stubs for pylance(vscode) compatiblity
              typeCheckingMode = "basic",
              diagnosticSeverityOverrides = {
                reportShadowedImports = "warning",
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428
      capabilities.offsetEncoding = { "utf-16" }

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      require("lsp_signature").setup({
        hint_enable = false,
        handler_opts = {
          border = "none", -- double, rounded, single, shadow, none, or a table of borders
        },
      })

      -- Setup handlers with our keymaps
      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client, buffer)
              require("plugins.lsp.keymaps").on_attach(client, buffer)
              require("plugins.lsp.autocmds").on_attach(client, buffer)
              require("plugins.lsp.format").on_attach(client, buffer)
            end,
            settings = servers[server_name],
          })
        end,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "none",
        silent = true,
      })

      -- Diagnostics Settings
      vim.diagnostic.config(opts.diagnositics)
      -- “Severity signs” are signs for severity levels of problems in your code.
      -- By default, they are E for Error, W for Warning, H for Hints, I for Informations.
      local signs = require('utils').icons.diagnostics 
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- formatting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern("go.mod", ".venv", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.black,
          nls.builtins.formatting.gofmt,
        },
      }
    end,
  },

  -- Useful status updates for LSP
  {
    "j-hui/fidget.nvim",
    event = { "LspAttach" },
    opts = {
      sources = {
        ["null-ls"] = { ignore = false },
      },
    },
  },
  -- python type stubs for pyright.
  -- installed as a plugin to use lazy for updates
  -- set path to:
  -- vim.fn.stdpath("data") .. "/lazy/python-type-stubs"
  {
    "microsoft/python-type-stubs",
    version = false,
    lazy = true,
  }
}
