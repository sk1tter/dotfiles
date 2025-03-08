local M = {}

M.icons = {
  navic = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = " ",
    Interface = " ",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = " ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = " ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
  gitsigns = {
    add = { text = "│" },
    topdelete = { text = "⏵" },
    delete = { text = "│" },
    changedelete = { text = "│" },
    change = { text = "│" },
    untracked = { text = "│" },
  },
  diagnostics = { Error = " ", Warn = " ", Hint = " ", Info = " " },
}

M.trim_whitespace = function()
  local pattern = [[%s/\s\+$//e]]
  local cur_view = vim.fn.winsaveview()
  vim.cmd(string.format("keepjumps keeppatterns silent! %s", pattern))
  vim.fn.winrestview(cur_view)
end

-- from mini.nvim
M.greeter = function()
  local hour = tonumber(vim.fn.strftime("%H"))
  -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
  local part_id = math.floor((hour + 4) / 8) + 1
  local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
  local username = vim.loop.os_get_passwd()["username"] or "USERNAME"

  return ("Good %s, %s"):format(day_part, username)
end

local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- { "", "", "", "", "", "" }

local filled_bar_chars = { first = "", middle = "", last = "" }
local empty_bar_chars = { first = "", middle = "", last = "" }
local progress_bar = function(progress, bar_length)
  local filled_length = math.floor(progress / bar_length)
  local empty_length = bar_length - filled_length
  local first_char = filled_length > 0 and filled_bar_chars.first or empty_bar_chars.first
  local last_char = empty_length > 0 and empty_bar_chars.last or filled_bar_chars.last

  return first_char
    .. string.rep(filled_bar_chars.middle, filled_length)
    .. string.rep(empty_bar_chars.middle, empty_length)
    .. last_char
end

-- match lsp with buffer filetype
local lsp_main_client = function()
  local clients = vim.lsp.get_clients()
  local buf_ft = vim.bo.filetype
  local clients_names = {}
  for _, client in ipairs(clients) do
    local lsp_filetype = client.config.filetypes or {}
    if vim.tbl_contains(lsp_filetype, buf_ft) and not vim.tbl_contains({ "null-ls", "copilot" }, client.name) then
      table.insert(clients_names, client.name)
    end
  end
  if #clients_names == 0 then
    return ""
  end
  return ":" .. table.concat(clients_names, ":")
end

M.is_wide_term = function(width)
  width = width or 90
  return vim.o.columns > width
end

-- lsp progress for statusline
M.lsp_progress = function()
  -- via https://www.reddit.com/r/neovim/comments/o4bguk/comment/h2kcjxa/
  local messages = vim.lsp.status()
  if #messages == 0 then
    return lsp_main_client()
  end
  local client = messages[1].name and messages[1].name .. ": " or ""
  local progress = messages[1].percentage or 0
  local task = messages[1].title or ""
  -- task = task:gsub("^(%w+).*", "%1") -- only first word
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners

  if M.is_wide_term(150) then
    local bar = progress_bar(progress, 10)
    return ":" .. client .. task .. " " .. bar .. " " .. spinners[frame + 1]
  end

  return ":" .. client .. task .. " " .. progress .. "%% " .. " " .. spinners[frame + 1]
end

-- copilot indicator
M.copilot_indicator = function()
  local client = vim.lsp.get_clients({ name = "copilot" })[1]
  if client == nil then
    return ""
  end

  if vim.tbl_isempty(client.requests) then
    return "" -- default icon whilst copilot is idle
  end

  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  return spinners[frame + 1]
end

M.pyright_python = function()
  local pyright = vim.lsp.get_clients({ name = "pyright" })[1]
  if pyright == nil then
    return nil
  end
  local pyright_path = pyright.config.settings.python.pythonPath
  if pyright_path ~= nil then
    return string.gsub(pyright_path, "/bin/python", "")
  end
  return nil
end

M.based_pyright_python = function()
  local bpyright = vim.lsp.get_clients({ name = "basedpyright" })[1]
  if bpyright == nil then
    return nil
  end
  local bpyright_path = bpyright.config.settings.python.pythonPath
  if bpyright_path ~= nil then
    return string.gsub(bpyright_path, "/bin/python", "")
  end
  return nil
end

M.parse_venv = function(venv)
  if venv ~= nil and string.find(venv, "/") then
    local orig_venv = venv
    for w in orig_venv:gmatch("([^/]+)") do
      venv = w
    end
    venv = string.format("%s", venv)
  end
  return venv
end

M.find_venv_path = function()
  if not require("lazy.core.config").plugins["nvim-lspconfig"]._.loaded then
    return ""
  end
  local cwd = vim.fn.getcwd()
  local path = require("lspconfig/util").path

  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local poetry_match = vim.fn.glob(path.join(cwd, "poetry.lock"))
  if poetry_match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return path.join(venv, "bin", "python")
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ "*", ".*" }) do
    local venv_match = vim.fn.glob(path.join(cwd, pattern, "pyvenv.cfg"))
    if venv_match ~= "" then
      return path.join(path.dirname(venv_match), "bin", "python")
    end
  end

  return ""
end

-- Reuse gitsigns.nvim data for lualine
M.diff_source = function()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

M.copy_relative_path = function()
  local filename = vim.fn.expand("%")
  vim.api.nvim_echo({ { "Copying filename to clipboard: " .. filename } }, false, {})
  vim.cmd("call provider#clipboard#Call('set', [ ['" .. filename .. "'], 'v','\"'])")
end

M.copy_absolute_path = function()
  local filename = vim.fn.expand("%:p")
  vim.api.nvim_echo({ { "Copying filename to clipboard: " .. filename } }, false, {})
  vim.cmd("call provider#clipboard#Call('set', [ ['" .. filename .. "'], 'v','\"'])")
end

M.statusline_indent_guide = {
  function()
    local style = vim.bo.expandtab and "Spaces" or "Tabs"
    local size = vim.bo.expandtab and vim.bo.shiftwidth or vim.bo.tabstop
    -- local size = vim.bo.shiftwidth -- vim-sleuth sets shiftwidth
    return style .. ": " .. size
  end,
  cond = function()
    local ignore_ft = { "gitcommit", "gitrebase", "alpha", "help", "TelescopePrompt", "vim", "", "minimap" }
    return not vim.tbl_contains(ignore_ft, vim.bo.filetype)
  end,
  on_click = function(_)
    vim.cmd("Sleuth")
  end,
}

M.project_files = function()
  local opts = {} -- define here if you want to define something
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    require("telescope.builtin").git_files(opts)
  else
    require("telescope.builtin").find_files(opts)
  end
end

M.is_image = function(filepath)
  local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
  local split_path = vim.split(filepath:lower(), ".", { plain = true })
  local extension = split_path[#split_path]
  return vim.tbl_contains(image_extensions, extension)
end

return M
