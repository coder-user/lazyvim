-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local mappings = {
  n = {
    ["J"] = { "6j", desc = "" },
    ["K"] = { "6k", desc = "" },
    ["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
  v = {
    ["J"] = { "6j", desc = "" },
    ["K"] = { "6k", desc = "" },
  },
  t = {
    ["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
}
-- vim.keymap.set(
--   { "n", "i", "v", "x" },
--   "te",
--   '<CMD>lua require("code.telescope-customcmd").showCommandBar()<CR>',
--   { desc = "customcmd action" }
-- )
vim.keymap.set(
  { "n", "i", "v", "x" },
  "<A-CR>",
  '<CMD>lua require("code.telescope-customcmd").showCommandBar()<CR>',
  { desc = "customcmd action" }
)
-- ["Y"] = { '"+y', desc = "Copy selection to system clipboard" },

for mode, map in pairs(mappings) do
  for lhs, rhs in pairs(map) do
    local desc = rhs.desc or ""
    local cmd = rhs[1] or ""
    vim.keymap.set(mode, lhs, cmd, { desc = desc })
  end
end
