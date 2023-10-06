-- copied from lazyvim
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = require("utils").greeter()
      local header_padding = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", [[:lua require("utils").project_files() <CR>]]),
        dashboard.button("n", " " .. " New file", [[:ene <BAR> startinsert <CR>]]),
        dashboard.button("e", " " .. " Explore files", [[:Ex <CR>]]),
        dashboard.button("r", " " .. " Recent files", [[:Telescope oldfiles <CR>]]),
        dashboard.button("g", " " .. " Find text", [[:Telescope live_grep <CR>]]),
        dashboard.button("c", " " .. " Config", [[:e $MYVIMRC <CR>]]),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <CR>]]),
        dashboard.button("p", " " .. " Plugins", [[:Lazy<CR>]]),
        dashboard.button("q", " " .. " Quit", [[:qa<CR>]]),
      }
      dashboard.opts.layout[1].val = header_padding
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
