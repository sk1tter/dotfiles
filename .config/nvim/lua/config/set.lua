-- [[ Setting options ]]
-- See `:help vim.o`

-- Ignore compiled files
vim.opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*", "*/.venv/*" }

-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Make line numbers default
vim.wo.number = true

-- Set relative line numbers
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

vim.opt.smartindent = true

-- Line breaking and indents
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.linebreak = true

-- persistent undo
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- No swap files, viva la vida
vim.opt.swapfile = false

-- Make it so there are always ten lines below my cursor
vim.opt.scrolloff = 10

-- listchars
vim.opt.list = true
vim.opt.listchars:append "eol:↵"

-- Set clipboard to use system clipboard
-- vim.opt.clipboard = "unnamedplus"

-- Cursorline highlighting control
vim.opt.cursorline = true -- Highlight the current line

-- Folds
vim.opt.foldlevel = 99 -- high flodlevel means all folds are open
vim.opt.foldmethod = 'expr'
vim.o.foldtext =
[[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.o.fillchars =
[[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.foldcolumn = '1'

-- [[ Diagnostics Settings ]]
-- “Severity signs” are signs for severity levels of problems in your code.
-- By default, they are E for Error, W for Warning, H for Hints, I for Informations.
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    -- source = "always",
    prefix = '●',
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})
