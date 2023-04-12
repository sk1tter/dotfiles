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
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			char = "│",
			filetype_exclude = { "help", "Trouble", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
			show_current_context_start = false,
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
}
