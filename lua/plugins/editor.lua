if true then
  return {}
end

return {
  { "chrisgrieser/nvim-spider", lazy = true },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        ["<leader>l"] = { name = "+format" },
        ["\\u"] = { name = "+ui" },
        ["<leader>t"] = { name = "+test" },
      },
    },
  },
  {
    "Pocco81/auto-save.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("auto-save").setup({
        enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
        execution_message = {
          message = function() -- message to print on save
            -- return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
            return ""
          end,
          dim = 0.18, -- dim the color of `message`
          cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
        },
        trigger_events = { "InsertLeave" },
        -- trigger_events = { "InsertLeave", "TextChanged" },

        debounce_delay = 3333,
      })
    end,
  },
  {
    "mg979/vim-visual-multi",
    config = function()
      local hlslens = require("hlslens")
      if hlslens then
        local overrideLens = function(render, posList, nearest, idx, relIdx)
          local _ = relIdx
          local lnum, col = unpack(posList[idx])
          local text, chunks
          if nearest then
            text = ("[%d/%d]"):format(idx, #posList)
            chunks = { { " ", "Ignore" }, { text, "VM_Extend" } }
          else
            text = ("[%d]"):format(idx)
            chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
        local lensBak
        local config = require("hlslens.config")
        local gid = vim.api.nvim_create_augroup("VMlens", {})
        vim.api.nvim_create_autocmd("User", {
          pattern = { "visual_multi_start", "visual_multi_exit" },
          group = gid,
          callback = function(ev)
            if ev.match == "visual_multi_start" then
              lensBak = config.override_lens
              config.override_lens = overrideLens
            else
              config.override_lens = lensBak
            end
            hlslens.start()
          end,
        })
      end
    end,
  },
  -- current config with lazy.nvim
  {
    "kevinhwang91/nvim-hlslens",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "n",
        [[<cmd>execute('normal! ' . v:count1 . 'n')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
      },
      {
        "N",
        [[<cmd>execute('normal! ' . v:count1 . 'N')<cr>]] .. [[<cmd>lua require("hlslens").start()<cr>]],
      },
      { "*", "*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "#", "#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "g*", "g*" .. [[<cmd>lua require("hlslens").start()<cr>]] },
      { "g#", "g#" .. [[<cmd>lua require("hlslens").start()<cr>]] },
    },
    config = function()
      require("hlslens").setup({
        calm_down = true,
        override_lens = function(render, plist, nearest, idx, r_idx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local abs_r_idx = math.abs(r_idx)
          if abs_r_idx > 1 then
            indicator = string.format("%d%s", abs_r_idx, sfw ~= (r_idx > 1) and "" or "")
          elseif abs_r_idx == 1 then
            indicator = sfw ~= (r_idx == 1) and "" or ""
          else
            indicator = ""
          end

          local lnum, col = unpack(plist[idx])
          if nearest then
            local cnt = #plist
            if indicator ~= "" then
              text = string.format("[%s %d/%d]", indicator, idx, cnt)
            else
              text = string.format("[%d/%d]", idx, cnt)
            end
            chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
          else
            text = string.format("[%s %d]", indicator, idx)
            chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
          end
          render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
        end,
      })
    end,
  },
}
