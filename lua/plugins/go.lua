if false then
  return {}
end

return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl", "goimports_reviser" })
        end,
      },
    },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.formatting.goimports_reviser, -- 导入顺序的支持
        -- nls.builtins.formatting.goimports,
        -- nls.builtins.formatting.gofumpt,
      })
    end,
  },
}
