return {
  { "chrisgrieser/nvim-spider", lazy = true },
  {
    "Pocco81/auto-save.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("auto-save").setup({
        enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
        execution_message = {
          message = function() -- message to print on save
            -- return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            return ""
          end,
          dim = 0.18, -- dim the color of `message`
          cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        trigger_events = { "InsertLeave" },
        -- trigger_events = { "InsertLeave", "TextChanged" },

        debounce_delay = 3333,
      })
    end,
  },
}
