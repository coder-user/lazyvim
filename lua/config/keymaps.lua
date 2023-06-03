-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 键盘映射设置
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

local utils = require("utils")
local is_available = utils.is_available

-- Comment
if is_available("Comment.nvim") then
  mappings.n["<leader>tc"] = {
    function()
      require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
    end,
    desc = "Comment line",
  }
  mappings.v["<leader>tc"] =
    { "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", desc = "Toggle comment line" }
end

-- 遍历 mappings 表，设置键盘映射
for mode, map in pairs(mappings) do
  for lhs, rhs in pairs(map) do
    local desc = rhs.desc or ""
    local cmd = rhs[1] or ""
    vim.keymap.set(mode, lhs, cmd, { desc = desc })
  end
end
