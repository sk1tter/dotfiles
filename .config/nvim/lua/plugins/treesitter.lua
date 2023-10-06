return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        "bash",
        "c",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "scala",
        "typescript",
        "vimdoc",
        "vim",
        "yaml",
      },
      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
      context_commentstring = { enable = true, enable_autocmd = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require("nvim-treesitter.configs").setup(opts)
      -- fold with treesitter
      -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   event = { "BufReadPost", "BufNewFile" },
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   opts = {
  --     max_lines = 1,
  --   },
  -- },
}
