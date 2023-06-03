return {
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    ensure_installed = {
      "bash",
      "c",
      "help",
      "html",
      "javascript",
      "json",
      "lua",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "yaml",
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 1000,
    },
  },
  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
       ██████╗ ██████╗  ██████╗ ██╗     ██╗     ██╗██╗   ██╗███████╗██╗    ██╗          Z
      ██╔════╝██╔═══██╗██╔═══██╗██║     ██║     ██║██║   ██║╚══███╔╝██║    ██║      Z
      ██║     ██║   ██║██║   ██║██║     ██║     ██║██║   ██║  ███╔╝ ██║ █╗ ██║   z       
      ██║     ██║   ██║██║   ██║██║     ██║     ██║██║   ██║ ███╔╝  ██║███╗██║ z  
      ╚██████╗╚██████╔╝╚██████╔╝███████╗███████╗██║╚██████╔╝███████╗╚███╔███╔╝
      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝ ╚═════╝ ╚══════╝ ╚══╝╚══╝ 
      ]]
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
  },
}
