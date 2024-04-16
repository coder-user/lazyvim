if false then
  return {}
end

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "staticcheck",
        "golangci-lint",
      })
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({
        -- prompt for return type
        prompt_func_return_type = {
          go = true,
        },
        -- prompt for function parameters
        prompt_func_param_type = {
          go = false,
        },
      })
    end,
  },
  {
    "edolphin-ydf/goimpl.nvim",
    enabled = true,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("telescope").load_extension("goimpl")
    end,
  },
}
