return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })

      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          'c',
          'cpp',
          'go',
          'lua',
          'python',
          'vimdoc',
          'vim',
          'markdown',
          'html',
          'json',
          'bash',
          'scala',
          'typescript',
          'javascript',
        },
        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<nop>',
            node_decremental = '<bs>',
          },
        },
      }
      -- fold with treesitter
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      max_lines = 1,
    },
  },
}
