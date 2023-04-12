local function augroup(name)
	return vim.api.nvim_create_augroup("dp_group_" .. name, { clear = true })
end

-- Start vim with clean jump list
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	group = augroup("clean_jumplist"),
	callback = function()
		vim.cmd.clearjumps()
	end,
})

-- Resize splits when window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = "*",
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Check if file needs reloading when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("reload_checktime"),
	command = "checktime",
})

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = augroup("yank_highlight"),
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})

-- Only have cursorline highlighting in the active buffer
local group = augroup("window_control")
local set_cursorline = function(event, value, pattern)
	vim.api.nvim_create_autocmd(event, {
		group = group,
		pattern = pattern,
		callback = function()
			-- return if number and relativenumber are both not set
			vim.opt_local.cursorline = value
			if not vim.opt_local.number:get() and not vim.opt_local.relativenumber:get() then
				return
			end
			vim.opt_local.relativenumber = value
		end,
	})
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("goto_last_location"),
	callback = function()
		local ignore_ft = { "gitcommit", "gitrebase" }
		if vim.tbl_contains(ignore_ft, vim.bo.filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"help",
		"lspinfo",
		"man",
		"qf",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- start terminal in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup("terminal_open"),
	pattern = "*",
	command = "startinsert",
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
