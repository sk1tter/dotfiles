lua <<EOF
require("nvim-treesitter.configs").setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = false,
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}
EOF

