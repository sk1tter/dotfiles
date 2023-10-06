vim.g.neovide_cursor_trail_legnth = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
vim.g.neovide_remember_window_size = false

vim.keymap.set("n", "<D-s>", ":w<CR>")

vim.keymap.set("v", "<D-c>", [["+y]], { noremap = true, silent = true })
vim.keymap.set("", "<D-v>", [[+p<CR>]], { noremap = true, silent = true })
vim.keymap.set("!", "<D-v>", [[<C-R>+]], { noremap = true, silent = true })
vim.keymap.set("t", "<D-v>", [[<C-R>+]], { noremap = true, silent = true })
vim.keymap.set("v", "<D-v>", [[<C-R>+]], { noremap = true, silent = true })

vim.o.guifont = "Jetbrains Mono,FiraCode_Nerd_Font_Mono:h13"

