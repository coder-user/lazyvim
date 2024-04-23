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

for mode, map in pairs(mappings) do
  for lhs, rhs in pairs(map) do
    local desc = rhs.desc or ""
    local cmd = rhs[1] or ""
    vim.keymap.set(mode, lhs, cmd, { desc = desc })
  end
end

vim.keymap.del("n", "<leader>l")

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

local function toggle_window_size()
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

vim.keymap.set({ "n" }, "<leader>wz", function()
  toggle_window_size()
end, { desc = "Split window down" })

local windows_original_width = {}

local function maximize_current_window()
  -- 存储所有窗口的原始宽度
  windows_original_width = {}
  local cur_win = vim.api.nvim_get_current_win()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    windows_original_width[win] = vim.api.nvim_win_get_width(win)
  end

  -- 最大化当前窗口
  local total_width = vim.api.nvim_get_option("columns")
  vim.api.nvim_win_set_width(cur_win, total_width)
end

local function restore_windows()
  -- 恢复所有窗口到其原始宽度
  for win, width in pairs(windows_original_width) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_width(win, width)
    end
  end
end

local original_width = nil

local function toggle_window_size2()
  local cur_win = vim.api.nvim_get_current_win()

  -- 如果原始宽度未记录，则记录当前窗口的宽度
  if original_width == nil then
    original_width = vim.api.nvim_win_get_width(cur_win)
  end

  -- 获取总宽度
  local total_width = vim.api.nvim_get_option("columns")

  -- 判断当前窗口是否已经是最大宽度
  if vim.api.nvim_win_get_width(cur_win) < total_width then
    -- 如果不是最大，则将窗口宽度设置为最大
    vim.api.nvim_win_set_width(cur_win, total_width)
  else
    -- 如果已是最大宽度，将宽度设置为原始宽度
    vim.api.nvim_win_set_width(cur_win, original_width)
    -- 恢复完成后清空原始宽度
    original_width = nil
  end
end

local original_width = nil
local original_height = nil

local function toggle_window_size3()
  local cur_win = vim.api.nvim_get_current_win()

  -- 如果原始尺寸未记录，则记录当前窗口的尺寸
  if original_width == nil or original_height == nil then
    original_width = vim.api.nvim_win_get_width(cur_win)
    original_height = vim.api.nvim_win_get_height(cur_win)
  end

  -- 获取总宽度和总高度
  local total_width = vim.api.nvim_get_option("columns")
  local total_height = vim.api.nvim_get_option("lines")

  -- 判断当前窗口是否已经是最大尺寸
  if vim.api.nvim_win_get_width(cur_win) < total_width or vim.api.nvim_win_get_height(cur_win) < total_height then
    -- 如果不是最大，则将窗口尺寸设置为最大
    vim.api.nvim_win_set_width(cur_win, total_width)
    vim.api.nvim_win_set_height(cur_win, total_height)
  else
    -- 如果已是最大尺寸，将尺寸设置为原始尺寸
    vim.api.nvim_win_set_width(cur_win, original_width)
    vim.api.nvim_win_set_height(cur_win, original_height)
    -- 恢复完成后清空原始尺寸
    original_width = nil
    original_height = nil
  end
end
vim.keymap.set("n", "<leader>wm", function()
  toggle_window_size3()
end, { desc = "Maximize current window" })

vim.keymap.set("n", "<leader>ws", function()
  restore_windows()
end, { desc = "Restore all windows" })
