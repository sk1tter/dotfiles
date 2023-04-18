-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>fv", vim.cmd.Ex, { desc = "[f]ile [v]iew" })

-- Remap for better up and down with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap to keep cursor in middle of screan when moving half package
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("x", "<leader>p", [["_dP]])

-- Easy window resizing
vim.keymap.set("n", "=", [[<cmd>vertical resize +2<cr>]], { silent = true }) -- make window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -2<cr>]], { silent = true }) -- make window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { silent = true }) -- make window bigger horizontally
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { silent = true }) -- make window smaller horizontally

-- Easy window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Keymaps for terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Escape terminal" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Move between buffers
vim.keymap.set("n", "[b", vim.cmd.bprevious, { desc = "Move to previous buffer" })
vim.keymap.set("n", "]b", vim.cmd.bnext, { desc = "Move to next buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Outdent Line" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent Line" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

--- remove all trailing spaces
vim.keymap.set("n", "<F5>", "<cmd>lua require('utils').trim_whitespace()<CR>", { desc = "Remove trailing spaces" })

-- :Wq, :WQ, :W, :Q to :wq, :wq, :w, :q
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
