-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>fv", vim.cmd.Ex)

-- Remap for better up and down with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap to keep search results in middle of screan
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remap to keep cursor in middle of screan when moving half package
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("x", "<leader>p", [["_dP]])

-- Easy window resizing
vim.keymap.set("n", "=", [[<cmd>vertical resize +2<cr>]], { silent = true })   -- make window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -2<cr>]], { silent = true })   -- make window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { silent = true }) -- make window bigger horizontally
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { silent = true }) -- make window smaller horizontally

-- Easy window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- Keymaps for terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, noremap = true, desc = "Enter Normal Mode" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Move between buffers
if require("lazy.core.config").plugins["bufferline.nvim"] ~= nil then
  vim.keymap.set('n', '[b', vim.cmd.BufferLineCyclePrev, { desc = "Move to previous buffer" })
  vim.keymap.set('n', ']b', vim.cmd.BufferLineCycleNext, { desc = "Move to next buffer" })
else
  vim.keymap.set('n', '[b', vim.cmd.bprevious, { desc = "Move to previous buffer" })
  vim.keymap.set('n', ']b', vim.cmd.bnext, { desc = "Move to next buffer" })
end

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })


-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- save file
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })


-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- :Wq, :WQ, :W, :Q to :wq, :wq, :w, :q
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
