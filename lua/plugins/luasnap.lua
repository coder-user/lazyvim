if true then
  return {}
end

return {
  "L3MON4D3/LuaSnip",
  config = function()
    for language, snippets in pairs(require("code.snippets.init")) do
      require("luasnip").add_snippets(language, snippets)
    end
  end,
}
