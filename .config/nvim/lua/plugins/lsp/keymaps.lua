local M = {}

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
-- stylua: ignore
function M.on_attach(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", function() require("telescope.builtin").lsp_definitions() end, "[G]oto [D]efinition") -- vim.lsp.buf.definition
  nmap("gr", function() require("telescope.builtin").lsp_references() end, "[G]oto [R]eferences")
  nmap("gI", function() require("telescope.builtin").lsp_implementations() end, "[G]oto [I]mplementation")

  nmap("<leader>D", function() require("telescope.builtin").lsp_type_definitions() end, "Type [D]efinition")
  nmap("<leader>ds", function() require("telescope.builtin").lsp_document_symbols() end, "[D]ocument [S]ymbols")
  nmap("<leader>ws", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols()
  end, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Diagnostic keymaps
  nmap("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic message")
  nmap("]d", vim.diagnostic.goto_next, "Go to next diagnostic message")

  nmap("<leader>e", vim.diagnostic.open_float, "Open floating diagnostic message")
  -- nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list' )
end

return M
