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
