-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- º¸≈Ã”≥…‰…Ë÷√
local mappings = {
  n = {
    ["W"] = { "5w", desc = "Select 5 words forward" },
    ["B"] = { "5b", desc = "Select 5 words backward" },
    ["L"] = { "5j", desc = "Select 5 lines down" },
    ["H"] = { "5k", desc = "Select 5 lines up" },
    ["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  v = {
    ["W"] = { "5w", desc = "Select 5 words forward" },
    ["B"] = { "5b", desc = "Select 5 words backward" },
    ["L"] = { "5j", desc = "Select 5 lines down" },
    ["H"] = { "5k", desc = "Select 5 lines up" },
    ["Y"] = { '"+y', desc = "Copy selection to system clipboard" },
    ["<"] = { "<gv", desc = "Shift line left" },
    [">"] = { ">gv", desc = "Shift line right" },
  },
  i = {
    ["jj"] = { "<ESC>", desc = "Exit insert mode using 'jj'" },
    ["jk"] = { "<ESC>", desc = "Exit insert mode using 'jk'" },
  },
  t = {
    ["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
}

-- ±È¿˙ mappings ±Ì£¨…Ë÷√º¸≈Ã”≥…‰
for mode, map in pairs(mappings) do
  for lhs, rhs in pairs(map) do
    local desc = rhs.desc or ""
    local cmd = rhs[1] or ""
    vim.keymap.set(mode, lhs, cmd, { desc = desc })
  end
end
