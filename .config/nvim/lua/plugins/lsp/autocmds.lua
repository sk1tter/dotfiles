local M = {}
-- LSP Autocmds
-- This function gets run when an LSP connects to a particular buffer.
function M.on_attach(client, bufnr)
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

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight_onhold", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.inlayHintProvider then
    local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
    if type(ih) == "function" then
      ih(bufnr, true)
    elseif type(ih) == "table" and ih.enable then
      ih.enable(true, { bufnr = bufnr })
    end
  end
end

return M
