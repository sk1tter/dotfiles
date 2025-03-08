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
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- "ray-x/lsp_signature.nvim",

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
      diagnostics = {
        -- virtual_text = false,
        virtual_text = {
          source = "if_many",
          spacing = 2,
          -- prefix = "●",
          prefix = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              return "" -- Nerd font icon for error
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
              return "" -- Nerd font icon for warning
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
              return "" -- Nerd font icon for info
            else
              return "" -- Nerd font icon for hint
            end
          end,
        },
        update_in_insert = false,
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        float = {
          border = "rounded",
          source = "if_many", -- Or "if_many"
        },
      },
      -- global capabilities
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
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
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
        -- pyright = {
        --   python = {
        --     venvPath = ".venv",
        --     analysis = {
        --       useLibraryCodeForTypes = true,
        --       stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs", -- downloaded stubs for pylance(vscode) compatiblity
        --       typeCheckingMode = "basic",
        --       diagnosticSeverityOverrides = {
        --         reportShadowedImports = "warning",
        --       },
        --     },
        --   },
        -- },
        basedpyright = {
          basedpyright = {
            analysis = {
              -- turn off analysis
              ignore = { "*" },
              -- typecheckingmode = "off",
              -- useLibraryCodeForTypes = true,
              -- typeCheckingMode = "basic",
              -- diagnosticSeverityOverrides = {
              --   reportShadowedImports = "warning",
              -- },
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
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      -- Ensure the servers above are installed
      local mason_lspconfig = require("mason-lspconfig")

      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      mason_lspconfig.setup({
        ensure_installed = {}, -- we use mason-tool-installer to install the servers
        automatic_installation = false,
      })

      -- require("lsp_signature").setup({
      --   hint_enable = false,
      --   handler_opts = {
      --     border = "none", -- double, rounded, single, shadow, none, or a table of borders
      --   },
      -- })

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
      vim.diagnostic.config(opts.diagnostics)
      -- “Severity signs” are signs for severity levels of problems in your code.
      -- By default, they are E for Error, W for Warning, H for Hints, I for Informations.
      local signs = require("utils").icons.diagnostics
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
  -- formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufReadPre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      formaters_by_ft = {
        lua = { 'stylus' },
        python = { 'isort', 'ruff' },
      }
    }
  },

  -- {
  --   "nvimtools/none-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim" },
  --   opts = function()
  --     local nls = require("null-ls")
  --     return {
  --       root_dir = require("null-ls.utils").root_pattern("go.mod", ".venv", "Makefile", ".git"),
  --       on_attach = function(_, buf)
  --         require("plugins.lsp.format").on_attach(_, buf)
  --       end,
  --       sources = {
  --         nls.builtins.formatting.stylua,
  --         nls.builtins.formatting.shfmt,
  --         nls.builtins.formatting.isort,
  --         nls.builtins.formatting.black,
  --         nls.builtins.formatting.gofmt,
  --         nls.builtins.formatting.prettier,
  --       },
  --     }
  --   end,
  -- },

  -- Useful status updates for LSP
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
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
  },
}
