return {
  -- im-select
  {
    "keaising/im-select.nvim",
    enabled = true,
    event = "VimEnter",
    config = function()
      require("im_select").setup({})
    end,
  },
  -- 透明度
  {
    "xiyaowong/transparent.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      local ts = require("transparent")
      ts.clear_prefix("BufferLine")
      ts.clear_prefix("NeoTree")
      -- ts.clear_prefix("lualine")
      ts.setup({ -- Optional, you don't have to run setup.
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          -- "CursorLine",
          "CursorLineNr",
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer",
        },
        extra_groups = { "" }, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end,
  },
}
