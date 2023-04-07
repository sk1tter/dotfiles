local M = {}
-- LSP Autocmds
-- This function gets run when an LSP connects to a particular buffer.
function M.on_attach(client, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- -- Show Lsp signature help on cursor hold in insert mode
  -- if client.supports_method "textDocument/signatureHelp" then
  --   vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
  --     pattern = "*",
  --     group = vim.api.nvim_create_augroup("lsp_signature_help", {}),
  --     callback = function()
  --       vim.lsp.buf.signature_help()
  --     end,
  --   })
  -- end
  require("lsp_signature").on_attach({
    hint_enable = false,
    handler_opts = {
      border = "none"   -- double, rounded, single, shadow, none, or a table of borders
    },
  }, bufnr)  -- Note: add in lsp client on-attach

  -- Show diagnostics under the cursor when holding position
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    group = vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true }),
    callback = function()
      -- Check if a floating dialog exists and if not
      -- then check for diagnostics under the cursor
      for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
          return
        end
      end
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
    end,
  })
end

return M
