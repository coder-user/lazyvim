return {
  -- 添加 symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- 在这里添加应该传递到 setup() 的 options
      position = "right",
    },
  },
}
