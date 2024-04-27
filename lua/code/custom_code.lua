local M = {}

-- 跟踪当前窗口是否已被最大化
M.is_maximized = false
-- 存储每个窗口的原始大小
M.original_sizes = {}

-- 存储当前所有窗口的大小，以便恢复
local function store_original_sizes()
  M.original_sizes = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    M.original_sizes[win] = {
      width = vim.api.nvim_win_get_width(win),
      height = vim.api.nvim_win_get_height(win),
    }
  end
end

-- 切换当前窗口的大小。如果窗口未最大化，它将最大化窗口；如果已最大化，则恢复原始大小。
function M.toggle_window_max_size()
  local cur_win = vim.api.nvim_get_current_win()
  local cur_width = vim.api.nvim_win_get_width(cur_win)
  local cur_height = vim.api.nvim_win_get_height(cur_win)
  local total_width = vim.api.nvim_get_option("columns")
  local total_height = vim.api.nvim_get_option("lines")

  if not M.is_maximized and (cur_width < total_width or cur_height < total_height) then
    store_original_sizes()
    vim.api.nvim_win_set_width(cur_win, total_width)
    vim.api.nvim_win_set_height(cur_win, total_height)
    M.is_maximized = true
  else
    for win, size in pairs(M.original_sizes) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, size.width)
        vim.api.nvim_win_set_height(win, size.height)
      end
    end
    M.is_maximized = false
  end
end

-- go --

-- 折叠附近的错误行，从当前行开始，向下查找100行
function M.go_fold_nearby_100_errors()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local search_end_line = current_line + 100
  local total_lines = vim.api.nvim_buf_line_count(0)

  if search_end_line > total_lines then
    search_end_line = total_lines
  end
  local error_patterns = { "if%s+[^;]+;[^;]+!= nil", ".+,%s+err%s*[:=]+%s+.+%([^%)]*%)" }

  for line = current_line, search_end_line do
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    for _, pattern in ipairs(error_patterns) do
      if line_text:find(pattern) then
        vim.api.nvim_exec(tostring(line) .. "foldclose", false)
      end
    end
  end
end

-- 折叠文档中所有包含特定错误模式的行
function M.go_fold_all_errors()
  local total_lines = vim.api.nvim_buf_line_count(0)
  local error_patterns = { "if%s+[^;]+;[^;]+!= nil", ".+,%s+err%s*[:=]+%s+.+%([^%)]*%)" }

  for line = 1, total_lines do
    local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
    for _, pattern in ipairs(error_patterns) do
      if line_text:find(pattern) then
        vim.api.nvim_exec(tostring(line) .. "foldclose", false)
      end
    end
  end
end

function M.go_import_package_complete()
  local get_pkgs = function()
    local results = {}
    local list_pkg = io.popen("gopkgs"):read("*all")
    for line in list_pkg:gmatch("[^\n\r]+") do
      table.insert(results, line)
    end
    return results
  end

  local co = coroutine.create(function()
    local selectco = assert(coroutine.running(), "main thread!")
    local items = get_pkgs()
    vim.ui.select(items, { prompt = "Import Packages Path" }, function(choice)
      coroutine.resume(selectco, choice)
    end)
    local value = coroutine.yield()
    -- if cancel when select , then skip the following step, only return
    if value == nil or value == "" then
      return
    end

    local inputco = coroutine.running()
    vim.ui.input({ prompt = "Input Alias Pkg Name:" }, function(input)
      coroutine.resume(inputco, input)
    end)
    local aliase = coroutine.yield()

    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local next_line = line:sub(0, pos + 1) .. "\t" .. aliase .. '"' .. value .. '"' .. line:sub(pos + 2)
    vim.api.nvim_set_current_line(next_line)
    vim.lsp.buf.formatting()
  end)
  coroutine.resume(co)
end

return M
