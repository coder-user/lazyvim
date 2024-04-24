if false then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "K", false }
    end,
  },
  {
    "famiu/bufdelete.nvim",
    enabled = true,
    event = "VeryLazy",
    keys = {
      { "<leader>wx", "<cmd>Bdelete<cr>", desc = "Close Buffer" },
    },
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
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("live_grep_args")
          end)
        end,
      },
    },
    keys = {
      { "<C-S-F>", LazyVim.telescope("live_grep"), desc = "Grep (Root Dir)" },
      { "<C-S-N>", LazyVim.telescope("files"), desc = "Find Files (Root Dir)" },
      { "<C-F>", LazyVim.telescope("current_buffer_fuzzy_find"), desc = "Grep (Current file)" },
    },
  },
}
