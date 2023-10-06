local function augroup(name)
  return vim.api.nvim_create_augroup("dp_group_" .. name, { clear = true })
end

-- Start vim with clean jump list
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = "*",
  once = true,
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
set_cursorline("FileType", false, "TelecopePrompt")

-- Go to last location when opening a buffer
local restore_cursor_group = augroup("goto_last_location")
vim.api.nvim_create_autocmd("BufReadPost", {
  group = restore_cursor_group,
  callback = function(opts)
    vim.api.nvim_create_autocmd("FileType", {
      group = restore_cursor_group,
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].ft
        local mark = vim.api.nvim_buf_get_mark(opts.buf, '"')
        if not vim.tbl_contains({ "gitcommit", "gitrebase" }, ft) then
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      end,
    })
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
  callback = function(event)
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd.startinsert()
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_session_persistence"),
  pattern = { "gitcommit", "gitrebase" },
  callback = function()
    require("persistence").stop()
  end,
})

if vim.fn.executable("qlmanage") then
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("netrw_mapping"),
    pattern = "netrw",
    callback = function(event)
      vim.keymap.set("n", "gl", function()
        local filepath =
          vim.api.nvim_exec2("echo netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))", { output = true })
        vim.fn.jobstart({ "qlmanage", "-p", filepath["output"] })
      end, { buffer = event.buf, silent = true, desc = "Preview in Quick Look" })
    end,
  })
end
