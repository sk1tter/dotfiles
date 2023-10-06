return {
  {
    "tpope/vim-vinegar",
    lazy = false,
    config = function()
      vim.g.netrw_fastbrowse = 0
      vim.g.netrw_altfile = 1
    end,
  },
}
