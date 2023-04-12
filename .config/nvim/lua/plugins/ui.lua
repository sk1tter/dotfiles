local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- match lsp with buffer filetype
local lsp_main_client = function()
	local clients = vim.lsp.get_active_clients()
	local buf_ft = vim.bo.filetype
	for _, client in ipairs(clients) do
		local lsp_filetype = client.config.filetypes or {}
		if vim.tbl_contains(lsp_filetype, buf_ft) and not vim.tbl_contains({ "null-ls", "copilot" }, client.name) then
			return client.name
		end
	end
	return ""
end

-- lsp progress for statusline
local function lsp_progress()
	-- via https://www.reddit.com/r/neovim/comments/o4bguk/comment/h2kcjxa/
	local messages = vim.lsp.util.get_progress_messages()
	if #messages == 0 then
		return lsp_main_client()
	end
	local client = messages[1].name and messages[1].name .. ": " or ""
	local progress = messages[1].percentage or 0
	local task = messages[1].title or ""
	-- task = task:gsub("^(%w+).*", "%1") -- only first word

	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	return client .. task .. " " .. progress .. "%% " .. " " .. spinners[frame + 1]
end

-- copilot indicator
local copilot_indicator = function()
	local client = vim.lsp.get_active_clients({ name = "copilot" })[1]
	if client == nil then
		return ""
	end

	if vim.tbl_isempty(client.requests) then
		return "" -- default icon whilst copilot is idle
	end

	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	return spinners[frame + 1]
end

-- Reuse gitsigns.nvim data for lualine
local function diff_source()
	---@diagnostic disable-next-line: undefined-field
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

---@diagnostic disable-next-line: unused-local
local copy_relative_path = function(_nb_of_clicks, _button, _modifiers)
	local filename = vim.fn.expand("%")
	vim.api.nvim_echo({ { "Copying filename to clipboard: " .. filename } }, false, {})
	vim.cmd("call provider#clipboard#Call('set', [ ['" .. filename .. "'], 'v','\"'])")
end

---@diagnostic disable-next-line: unused-local
local copy_absolute_path = function(_nb_of_clicks, _button, _modifiers)
	local filename = vim.fn.expand("%:p")
	vim.api.nvim_echo({ { "Copying filename to clipboard: " .. filename } }, false, {})
	vim.cmd("call provider#clipboard#Call('set', [ ['" .. filename .. "'], 'v','\"'])")
end

return {
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "│" },
				topdelete = { text = "󱨉" },
				delete = { text = "│" },
				changedelete = { text = "│" },
				change = { text = "│" },
				untracked = { text = "│" },
			},
			preview_config = {
				border = "rounded",
				style = "minimal",
			},
		},
		keys = {
			{
				"<leader>gb",
				function()
					require("gitsigns").blame_line()
				end,
				desc = "[g]it [b]lame",
			},
			{
				"<leader>gd",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "[g]it [d]iff",
			},
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
						},
						{
							"diff",
							source = diff_source,
							on_click = function(_nb_of_clicks, _button, _modifiers)
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
							on_click = function(_nb_of_clicks, _button, _modifiers)
								vim.cmd.TroubleToggle("document_diagnostics")
							end,
						},
					},
					lualine_c = {
						{
							"filename",
							on_click = copy_relative_path,
						},
					},
					-- right
					lualine_x = {
						{
							lsp_progress,
							on_click = function()
								vim.cmd.LspInfo()
							end,
						},
						{ copilot_indicator },
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
							on_click = copy_absolute_path,
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
						{
							"filename",
							path = 4,
							separator = { left = "", right = "" },
							color = { bg = "none" },
						},
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
					{
						--[[ Fold Column ]]
						text = { builtin.foldfunc },
						click = "v:lua.ScFa",
						condition = { is_active_window },
					},
					{
						--[[ diagnostic column ]]
						sign = { name = { "Diagnostic" }, maxwidth = 1, colwidth = 1, auto = false },
						click = "v:lua.ScSa",
					},
					{
						--[[ number ]]
						text = { builtin.lnumfunc },
					},
					{
						--[[ git ]]
						sign = { name = { "GitSigns" }, maxwidth = 1, colwidth = 1, auto = false },
						click = "v:lua.ScSa",
					},
				},
				clickhandlers = {
					FoldOther = false,  -- Disable builtin clickhandler
				},
			}
		end,
	},

	{
		"SmiteshP/nvim-navic",
		event = "VeryLazy",
		opts = {
			separator = " > ",
			highlight = true,
			depth_limit = 5,
			depth_limit_indicator = "..",
			lsp = { auto_attach = true },
			icons = {
				File = " ",
				Module = " ",
				Namespace = " ",
				Package = " ",
				Class = " ",
				Method = " ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = " ",
				Interface = " ",
				Function = " ",
				Variable = " ",
				Constant = " ",
				String = " ",
				Number = " ",
				Boolean = " ",
				Array = " ",
				Object = " ",
				Key = " ",
				Null = " ",
				EnumMember = " ",
				Struct = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
			},
		},
	},
}
