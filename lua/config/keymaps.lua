-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 初始化键映射设置和删除函数
local set = vim.keymap.set
local del = vim.keymap.del

-- 引入自定义模块
local mecode = require("code.custom_code")

-- 删除现有的全局快捷键
del("n", "<leader>l")
del("n", "<leader>L")

-- 设置全局快捷键，增加移动距离
set({ "n", "v" }, "J", "6j")
set({ "n", "v" }, "K", "6k")
set({ "n", "v" }, "H", "6h")
set({ "n", "v" }, "L", "6l")

-- 设置全局快捷键，用于切换窗口最大化状态
set("n", "<leader>wm", mecode.toggle_window_max_size, { desc = "Toggle window max size" })
set("n", "<leader>fs", "<cmd>Telescope persisted<cr>", { desc = "Search history sessions" })

-- ############## go ##############
-- 设置 Go 文件专用快捷键，仅在当前缓冲区有效
local function golang_key_map_set()
  set("n", "<leader>le", mecode.go_fold_nearby_100_errors, { desc = "Go Err Fold Nearby", buffer = true })
  set("n", "<leader>lE", mecode.go_fold_all_errors, { desc = "Go Err Fold  All", buffer = true })
  set("n", "<leader>lI", mecode.go_import_package_complete, { desc = "Go Import Package", buffer = true })
  set({ "n", "i", "v", "x" }, "<A-S-CR>", require("code.telescope-customcmd").showGoCommandBar, { desc = "Customcmd Action", buffer = true })
  set({ "n", "i", "v", "x" }, "<A-CR>", "<CMD>GoCodeAction<CR>", { desc = "Go Action", buffer = true })
end

vim.api.nvim_set_keymap("n", "<leader>cp", ":lua require('luasnip').expand_or_jump()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_augroup("GoFileType", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "GoFileType",
  pattern = "go",
  callback = golang_key_map_set,
})
