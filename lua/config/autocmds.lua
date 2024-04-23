-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- auto save
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--   pattern = { "*" },
--   command = "silent! wall",
--   nested = true,
-- })

-- 默认关闭自动格式化
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- 退出文件前进行格式化
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*.go",
  callback = function()
    require("conform").format({ async = true, lsp_fallback = true })
  end,
})
