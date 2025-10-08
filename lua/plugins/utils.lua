
return {
  -- im-select
  {
    "keaising/im-select.nvim",
    enabled = true,
    event = "VimEnter",
    config = function()
      require("im_select").setup({
        default_command = "/opt/homebrew/bin/im-select",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = false,
    opts = {
      highlight = { enable = true },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    enabled = false,
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
}
