if vim.g.neovide then
  -- vim.o.guifont = "Maple Mono NF:h12"
  -- vim.o.guifont = "Monaspace Neon:h12"
  -- vim.o.guifont = "MonaspiceNe Nerd Font:h11"
  vim.o.guifont = "MonaspiceNe Nerd Font:h10"
  -- set guifont=FiraCode\ Nerd\ Font:h19
  vim.opt.linespace = 2

  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0
  vim.g.neovide_transparency = 1
  vim.g.neovide_show_border = true
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_frame = "transparent"
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_lifetime = 0.9
  vim.g.neovide_cursor_vfx_particle_density = 11.0
  vim.g.neovide_title_hidden = 1
  vim.g.neovide_fullscreen = false

  vim.keymap.set("i", "<C-S-v>", "<C-R>+") -- Paste insert mode
end
