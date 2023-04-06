-- [[ Setting options ]]
-- See `:help vim.o`

-- Ignore compiled files
vim.opt.wildignore = "__pycache__"
vim.opt.wildignore:append { "*.o", "*~", "*.pyc", "*pycache*" }

-- Set highlight on search
vim.opt.hlsearch = false
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
-- vim.opt.list = true
-- vim.opt.listchars:append "eol:↴"

-- vim.opt.clipboard = "unnamedplus"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Cursorline highlighting control
--  Only have it on in the active buffer
vim.opt.cursorline = true -- Highlight the current line
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

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
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end
  -- THIS IS FOR BUILTIN LSP
  vim.diagnostic.open_float({
    scope = "cursor",
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
    },
  })
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  command = "lua OpenDiagnosticIfNoFloat()",
  group = "lsp_diagnostics_hold",
})
