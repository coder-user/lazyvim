if true then
  return {}
end

-- 命令行自动补全
return {
  "hrsh7th/cmp-cmdline",
  config = function()
    local cmp = require("cmp")
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline({
        ["<CR>"] = {
          c = cmp.mapping.confirm({ select = false }),
        },
        ["<C-e>"] = {
          c = cmp.mapping.abort(),
        },
        ["<Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
        },
        ["<S-Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
            end
          end,
        },
      }),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
