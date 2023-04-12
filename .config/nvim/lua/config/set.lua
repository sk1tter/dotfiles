-- [[ Setting options ]]
-- See `:help vim.o`

-- Ignore compiled files
vim.opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*", "*/.venv/*", "*.DS_Store"})

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- Make line numbers default
vim.o.number = true

-- Set relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

vim.o.smartindent = true

-- Line breaking and indents
vim.o.breakindent = true
vim.o.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.o.linebreak = true

-- persistent undo
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- No swap files, viva la vida
vim.o.swapfile = false

-- Make it so there are always ten lines below my cursor
vim.o.scrolloff = 10

-- listchars
vim.o.list = false
vim.opt.listchars:append("eol:↵")

-- Set clipboard to use system clipboard
-- vim.o.clipboard = "unnamedplus"

-- Cursorline highlighting control
vim.o.cursorline = true -- Highlight the current line

-- Set tabstop to 4 spaces. Other settings are handled by vim-sleuth
vim.o.tabstop = 4

-- completion
vim.o.pumheight = 20 -- Makes popup menu smaller
vim.o.pumblend = 15 -- Transparent background 0 ~ 100

-- Folds
vim.o.foldlevel = 99 -- high flodlevel means all folds are open
vim.o.foldmethod = "expr"

-- ex) function _G.custom_fold_text() ... end (12 lines ) ----------------------
function _G.custom_fold_text()
	local start_line = vim.v.foldstart
	local end_line = vim.v.foldend
	local tabstop = vim.bo.tabstop
	local lines_in_fold = end_line - start_line + 1
	return vim.fn.substitute(vim.fn.getline(start_line), "\t", string.rep(" ", tabstop), "g")
		.. " ... "
		.. vim.fn.trim(vim.fn.getline(end_line))
		.. " ("
		.. lines_in_fold
		.. " lines) "
end

vim.o.foldtext = "v:lua.custom_fold_text()"

vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = "-",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
vim.o.foldcolumn = "1"

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
