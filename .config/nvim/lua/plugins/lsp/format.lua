local M = {}

function M.on_attach(_, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, { desc = "Format current buffer with LSP" })
end

return M
-- function M.on_attach(_, bufnr)
--   -- Create a command `:Format` local to the LSP buffer
--   vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
--     local ft = vim.bo[bufnr].filetype
--     local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
--
--     vim.lsp.buf.format({
--       bufnr = bufnr,
--       filter = function(client)
--         if have_nls then
--           return client.name == "null-ls"
--         end
--         return client.name ~= "null-ls"
--       end,
--     })
--   end, { desc = "Format current buffer with LSP" })
-- end
--
-- return M
