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

-- 支持单个分屏最大化和恢复
local original_sizes = {}
local is_maximized = false

local function store_original_sizes()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  original_sizes = {}
  for _, win in ipairs(wins) do
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)
    original_sizes[win] = { width = width, height = height }
  end
end

local function toggle_window_size()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_width = vim.api.nvim_win_get_width(cur_win)
  local cur_height = vim.api.nvim_win_get_height(cur_win)
  local total_width = vim.api.nvim_get_option("columns")
  local total_height = vim.api.nvim_get_option("lines")

  -- 检查是否已最大化
  if not is_maximized and (cur_width < total_width or cur_height < total_height) then
    -- 存储原始大小并最大化
    store_original_sizes()
    vim.api.nvim_win_set_width(cur_win, total_width)
    vim.api.nvim_win_set_height(cur_win, total_height)
    is_maximized = true
  else
    -- 恢复到原始大小
    for win, size in pairs(original_sizes) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, size.width)
        vim.api.nvim_win_set_height(win, size.height)
      end
    end
    is_maximized = false
  end
end

vim.keymap.set("n", "<leader>wm", toggle_window_size, { desc = "Toggle window max size" })

local function fold_if_error_found()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  local search_end_line = current_line + 100
  local total_lines = vim.api.nvim_buf_line_count(0)

  if search_end_line > total_lines then
    search_end_line = total_lines
  end
  local error_patterns = { "if err != nil ", "if err := ", "if err = " }

  for line = current_line, search_end_line do
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    for _, pattern in ipairs(error_patterns) do
      if line_text:find(pattern) then
        vim.api.nvim_exec(tostring(line) .. "foldclose", false)
      end
    end
  end
end

-- 定义一个自动命令组，以便于后续清理
vim.api.nvim_create_augroup("GoFileType", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "GoFileType",
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>le", fold_if_error_found, { desc = "go err fold" })
    vim.keymap.set(
      { "n", "i", "v", "x" },
      "<A-S-CR>",
      '<CMD>lua require("code.telescope-customcmd").showCommandBar()<CR>',
      { desc = "customcmd action", buffer = true }
    )
    vim.keymap.set({ "n", "i", "v", "x" }, "<A-CR>", "<CMD>GoCodeAction<CR>", { desc = "go action", buffer = true })
  end,
})
