-- simple alternative to fidget.nvim
local function lsp_progress()
  -- via https://www.reddit.com/r/neovim/comments/o4bguk/comment/h2kcjxa/
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then return "" end
  local client = messages[1].name and messages[1].name .. ": " or ""
  if client:find("null%-ls") then return "" end
  local progress = messages[1].percentage or 0
  local task = messages[1].title or ""
  task = task:gsub("^(%w+).*", "%1") -- only first word

  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  return client .. task .. " " .. progress .. "%% " .. " " .. spinners[frame + 1]
end

-- Reuse gitsigns.nvim data for lualine
local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end


return {
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    keys = {
      { "<leader>gb", function() require("gitsigns").blame_line() end,   desc = '[g]it [b]lame' },
      { "<leader>gd", function() require("gitsigns").preview_hunk() end, desc = '[g]it [d]iff' },
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'nord',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {
              "lazy",
              "netrw"
            }
          },
          globalstatus = true,
        },
        sections = {
          -- left
          lualine_a = { 'mode' },
          lualine_b = {
            { 'b:gitsigns_head', icon = '' },
            { 'diff',            source = diff_source },
            { 'diagnostics' },
          },
          lualine_c = {
            { "filename" },
          },
          -- right
          lualine_x = {
            { lsp_progress },
            { 'encoding' },
            { 'fileformat' },
            { 'filetype',  icon_only = true },
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        winbar = {},
        inactive_winbar = {
          lualine_x = {
            { 'filename', path = 4, color = { bg = 'NONE' } }
          },
        },
      })
    end,
  },

  {
    'akinsho/bufferline.nvim',
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local highlights = require("nord").bufferline.highlights({
        italic = true,
        bold = true,
      })
      require('bufferline').setup({
        options = {
          separator_style = "thin",
        },
        highlights = highlights,
      })
    end
  },

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
}
