-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local mappings = {
  n = {
    ["J"] = { "6j", desc = "" },
    ["K"] = { "6k", desc = "" },
    ["H"] = { "6h", desc = "" },
    ["L"] = { "6l", desc = "" },
  },
  v = {
    ["J"] = { "6j", desc = "" },
    ["K"] = { "6k", desc = "" },
    ["H"] = { "6h", desc = "" },
    ["L"] = { "6l", desc = "" },
  },
  i = {},
}
-- 定义一个自动命令组，以便于后续清理
vim.api.nvim_create_augroup("GoFileType", { clear = true })
-- 自动命令，对 Go 文件设置快捷键
vim.api.nvim_create_autocmd("FileType", {
  group = "GoFileType",
  pattern = "go",
  callback = function()
    vim.keymap.set(
      { "n", "i", "v", "x" },
      "<A-S-CR>",
      '<CMD>lua require("code.telescope-customcmd").showCommandBar()<CR>',
      { desc = "customcmd action", buffer = true }
    )
    vim.keymap.set({ "n", "i", "v", "x" }, "<A-CR>", "<CMD>GoCodeAction<CR>", { desc = "go action", buffer = true })
  end,
})

function toggle_window_size()
  -- 获取当前窗口的宽度和 Vim 的总宽度
  local cur_width = vim.api.nvim_win_get_width(0)
  local total_width = vim.api.nvim_get_option("columns")
  local threshold_width = math.floor(total_width * 0.8)

  -- 检查当前窗口是否已经是最大宽度
  if cur_width < threshold_width then
    -- 如果不是最大，则将窗口宽度设置为最大
    vim.api.nvim_win_set_width(0, total_width)
  else
    -- 如果已是最大宽度，将宽度设置为屏幕宽度的一半
    vim.api.nvim_win_set_width(0, math.floor(total_width / 2))
  end
end

vim.keymap.set({ "n" }, "<leader>wz", "<cmd>lua toggle_window_size()<CR>", { desc = "Split window down" })

for mode, map in pairs(mappings) do
  for lhs, rhs in pairs(map) do
    local desc = rhs.desc or ""
    local cmd = rhs[1] or ""
    vim.keymap.set(mode, lhs, cmd, { desc = desc })
  end
end
