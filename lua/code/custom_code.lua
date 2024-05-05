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
  local total_width = vim.o.columns
  local total_height = vim.o.lines

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

    -- 添加单行 if 块的判断逻辑
    if line_text:find("^%s*if.+{$") then
      local isSingleReturnBlock = false
      local lines = vim.api.nvim_buf_get_lines(0, line, line + 2, false)
      if #lines >= 2 and lines[#lines]:match("^%s*}%s*$") then
        if lines[1]:match("^%s*return%s+.+%s*$") then
          isSingleReturnBlock = true
        end
      end
      if isSingleReturnBlock then
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

function M.go_git_format_changed_files()
  -- 保存当前 buffer 的编号
  local current_buf = vim.api.nvim_get_current_buf()

  -- 获取项目的根目录
  local project_nvim = require("project_nvim.project")
  local project_root, detection_method = project_nvim.get_project_root()
  if project_root == nil then
    print("Project root not found!")
    return
  end

  -- 在项目根目录中执行 git 命令，找到所有修改过的文件
  local cmd = "git -C " .. project_root .. " diff --name-only HEAD"
  local all_modified_files = vim.fn.systemlist(cmd)

  -- 使用 Lua 过滤出 .go 文件
  local modified_go_files = {}
  for _, file in ipairs(all_modified_files) do
    if string.match(file, "%.go$") then -- 正则表达式匹配 .go 结尾的文件
      table.insert(modified_go_files, file)
    end
  end

  if #modified_go_files == 0 then
    return
  end

  -- 遍历所有修改过的文件并格式化
  for _, file in ipairs(modified_go_files) do
    local full_path = project_root .. "/" .. file
    -- 检查文件是否真实存在
    if vim.fn.filereadable(full_path) == 1 then
      -- 打开文件
      vim.cmd("e " .. full_path)
      -- 使用 conform 格式化文件
      require("conform").format({ async = true, lsp_fallback = true })
      -- 保存文件
      vim.cmd("w")
    else
      print("File not found: " .. full_path)
    end
  end

  -- 返回到最初的 buffe
  vim.api.nvim_set_current_buf(current_buf)
end

local function update_guifont_setting(font_setting)
  local config_path = vim.fn.stdpath("config") .. "/lua/config/neovide.lua" -- 指向正确的配置文件路径
  local new_setting_line = 'vim.o.guifont = "' .. font_setting .. '"'

  local file = io.open(config_path, "r")
  local lines = {}
  local found = false

  if file then
    for line in file:lines() do
      if line:match("^vim.o.guifont =") then
        table.insert(lines, new_setting_line)
        found = true
      else
        table.insert(lines, line)
      end
    end
    file:close()

    if not found then
      table.insert(lines, new_setting_line)
    end

    file = io.open(config_path, "w")
    for _, line in ipairs(lines) do
      file:write(line .. "\n")
    end
    file:close()
    print("Font setting updated and saved to config file.")
  else
    print("Failed to open config file.")
  end
end

function M.neovide_select_font()
  local fonts = {
    "Maple Mono NF:h11",
    "MonaspiceNe Nerd Font:h11",
    "FiraCode Nerd Font Mono:h11",
    "FiraCode Nerd Font:h11",
    "JetBrainsMono Nerd Font Mono:h11",
    "JetBrainsMono Nerd Font:h11",
  }

  vim.ui.select(fonts, { prompt = "Select Font:" }, function(choice)
    if choice then
      vim.o.guifont = choice
      update_guifont_setting(choice) -- 更新配置文件
      print("Font set to " .. choice)
    else
      print("Font selection cancelled.")
    end
  end)
end

return M
