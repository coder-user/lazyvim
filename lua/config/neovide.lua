if vim.g.neovide == false then
  return {}
end

-- 设置 GUI 字体和大小
vim.o.guifont = "Maple Mono NF:h11"
-- vim.o.guifont = "Monaspace Neon:h12" -- 字体选项
-- vim.o.guifont = "MonaspiceNe Nerd Font:h11" -- 字体选项
-- vim.o.guifont = "MonaspiceNe Nerd Font:h10" -- 当前字体和大小设置
-- set guifont=FiraCode\ Nerd\ Font:h19 -- 另一种字体设置示例
vim.opt.linespace = 2 -- 行间距

-- Neovide 窗口设置
vim.g.neovide_window_blurred = true -- 开启窗口模糊，默认值：false，说明：当窗口失焦时应用模糊效果
vim.g.neovide_floating_blur_amount_x = 1.0 -- 浮动窗口X轴模糊量，默认值：5.0，说明：设置X轴上的模糊强度
vim.g.neovide_floating_blur_amount_y = 1.0 -- 浮动窗口Y轴模糊量，默认值：5.0，说明：设置Y轴上的模糊强度
vim.g.neovide_transparency = 1 -- 窗口透明度，默认值：1.0，说明：设置整个窗口的透明度
vim.g.neovide_show_border = true -- 显示窗口边框，默认值：true，说明：是否显示窗口边框
vim.g.neovide_floating_shadow = true -- 浮动窗口阴影，默认值：true，说明：浮动窗口是否显示阴影
vim.g.neovide_floating_z_height = 10 -- 浮动窗口Z轴高度，默认值：5，说明：设置浮动窗口在Z轴上的相对高度
vim.g.neovide_light_angle_degrees = 45 -- 光照角度，默认值：45，说明：设置光照效果的角度
vim.g.neovide_light_radius = 5 -- 光照半径，默认值：100，说明：设置光照效果的半径大小
vim.g.neovide_frame = "transparent" -- 窗口边框样式，默认值：none，说明：设置窗口边框的样式，"transparent" 为透明
vim.g.neovide_cursor_antialiasing = true -- 光标抗锯齿，默认值：true，说明：是否开启光标抗锯齿
vim.g.neovide_cursor_vfx_mode = "pixiedust" -- 光标视觉特效，默认值：none，说明：设置光标的视觉特效模式
vim.g.neovide_cursor_vfx_particle_lifetime = 1.0 -- 光标特效粒子生命时长，默认值：1.0，说明：粒子特效的持续时间
vim.g.neovide_cursor_vfx_particle_density = 10.0 -- 光标特效粒子密度，默认值：10.0，说明：粒子特效的密度
vim.g.neovide_cursor_vfx_particle_curl = 1.0 -- 光标特效粒子旋转，默认值：1.0，说明：控制光标特效中粒子的旋转强度
vim.g.neovide_cursor_vfx_particle_speed = 10.0 -- 光标特效粒子速度，默认值：10.0，说明：控制光标特效粒子的移动速度
vim.g.neovide_title_hidden = 1 -- 隐藏标题栏，默认值：0，说明：是否隐藏窗口标题栏
vim.g.neovide_fullscreen = false -- 全屏模式，默认值：false，说明：是否开启全屏模式
vim.g.neovide_refresh_rate = 60 -- 刷新率，默认值：60 Hz，说明：设置 Neovide 的屏幕刷新率
vim.g.neovide_hide_mouse_when_typing = true -- 输入时隐藏鼠标，默认值：true，说明：是否在打字时自动隐藏鼠标指针
vim.g.neovide_confirm_quit = false -- 退出确认，默认值：false，说明：退出 Neovide 时是否显示确认对话框
-- vim.g.neovide_cursor_animation_length = 0.13 -- 光标动画时长，默认值：0.13 秒，说明：光标动画的持续时间
-- vim.g.neovide_cursor_trail_size = 0.8 -- 光标尾巴大小，默认值：0.8，说明：光标尾巴的长度
-- vim.g.neovide_no_idle = false -- 禁用空闲时降低刷新率，默认值：false，说明：空闲时是否降低刷新率（解决全屏闪屏问题）
-- vim.g.neovide_profiler = false -- 性能分析器，默认值：false，说明：是否开启性能分析器
-- vim.g.neovide_remember_window_size = false -- 记住窗口大小，默认值：false，说明：是否记忆窗口的大小和位置
-- vim.g.neovide_input_use_logo = false -- 在 macOS 使用 Logo 键作为 Super 键，默认值：false，说明：是否将 Logo 键当作 Super 键使用
-- vim.g.neovide_scale_factor = 1.0 -- 窗口缩放比例，默认值：1.0，说明：窗口的缩放因子
-- vim.g.neovide_antialiasing = true -- 文本抗锯齿，默认值：true，说明：开启文本抗锯齿以提高文字显示的清晰度

vim.keymap.set("i", "<C-S-v>", "<C-R>+")
vim.keymap.set("n", "<C-S-v>", '"+P')
vim.keymap.set("v", "<C-S-v>", '"+P')
vim.keymap.set("c", "<C-S-v>", "<C-R>+")
vim.keymap.set("i", "<C-S-c>", '"+y')
vim.keymap.set("n", "<C-S-c>", '"+y')
vim.keymap.set("v", "<C-S-c>", '"+y')

local function change_font_size(delta)
  local current_font = vim.o.guifont
  local font_name, font_size = current_font:match("^(.*):h(%d+)$")
  if font_name and font_size then
    local new_size = tonumber(font_size) + delta
    if new_size > 5 then -- Prevent font size from being too small
      vim.o.guifont = font_name .. ":h" .. new_size
    end
  end
end

vim.keymap.set("n", "<leader>u=", function()
  change_font_size(1)
end, { silent = true, desc = "Increase Font Size" })
vim.keymap.set("n", "<leader>u-", function()
  change_font_size(-1)
end, { silent = true, desc = "Decrease Font Size" })
