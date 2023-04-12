return {
	{
		-- Color Scheme
		-- 'AlexvZyl/nordic.nvim',
		"shaunsingh/nord.nvim",
		priority = 1000,
		config = function()
			vim.g.nord_contrast = true
			vim.g.nord_borders = true
			vim.g.nord_italic = false
			-- vim.api.nvim_create_autocmd('ColorScheme', {
			-- 	group = vim.api.nvim_create_augroup('custom_highlights_nord', {}),
			-- 	pattern = 'nord',
			-- 	command ='hi Folded guibg=#3B4252' -- color fold text like cursorline
			-- })
			vim.cmd.colorscheme("nord")
		end,
	},
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = false,
	},
	{
		"EdenEast/nightfox.nvim",
		enabled = false,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		enabled = false,
	},
}
