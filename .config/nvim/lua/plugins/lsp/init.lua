-- NOTE: This is where your plugins related to LSP can be installed.
-- The configuration is done below. Search for lspconfig to find it below.
return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'ray-x/lsp_signature.nvim',

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/neodev.nvim',
        config = function()
          -- Setup neovim lua configuration
          require('neodev').setup()
        end,
      },
    },
    opts = {
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
          python = { venvPath = ".venv" },
        }
      }
    },
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- Setup mason so it can manage external tooling
      require('mason').setup()

      -- Ensure the servers above are installed
      local mason_lspconfig = require('mason-lspconfig')

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }


      -- Setup handlers with our keymaps
      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = function (client, buffer)
              require("plugins.lsp.keymaps").on_attach(client, buffer)
              require("plugins.lsp.autocmds").on_attach(client, buffer)
            end,
            settings = servers[server_name],
          }
        end,
      }
    end
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'copilot' },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
        },
      }
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      {
        '<leader>q',
        '<cmd>TroubleToggle document_diagnostics<cr>',
        silent = true,
        noremap = true,
        desc = "Open diagnostics list"
      },
      {
        '<leader>wq',
        '<cmd>TroubleToggle workspace_diagnostics<cr>',
        silent = true,
        noremap = true,
        desc = "Open [w]orkspace diagnostics"
      },
    },
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- Github copilot
  -- 'github/copilot.vim',
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('copilot').setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end
  },
}
