local snippets = {}

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- 创建一个 snippets 表
local snippets = {}

-- 创建一个针对 Go 语言的片段表
snippets.go = {}

-- 添加第一个 Go 语言片段
table.insert(
  snippets.go,
  s(
    "gomodel",
    fmt(
      [[
package model

import "context"

type (
    {interfaceName} Model interface {{
        Set(ctx context.Context, data {structName}) error
    }}

    {structName} struct {{
        Model
    }}
)

func (p *{structName}) TableName() string {{
    return "{tableName}"
}}
]],
      {
        interfaceName = i(1, "Interface"),
        structName = i(2, "StructName"),
        tableName = i(3, "table_names"),
      }
    )
  )
)

-- 添加 Go 语言的代码片段
-- table.insert(
--   snippets.go,
--   s(
--     "gocreatefunc",
--     fmt(
--       [[
-- func (m *mysql{UserModel}) Create(ctx context.Context, {userVar} model.{UserType}) error {{
--     do := query.{UserType}.WithContext(ctx)
--     if err := do.Create(&{userVar}); err != nil {{
--         return errdefs.Unknown(ecode.Error(bizcode.InternalServerError, reasoncode.{ErrorCode}, err.Error()))
--     }}
--     return nil
-- }}
-- ]],
--       {
--         UserType = i(1, "User"),
--         UserModel = f(function(args)
--           return args[1][1] .. "Model"
--         end, { 1 }),
--         userVar = f(function(args)
--           local device = args[1][1]
--           return device:sub(1, 1):lower() .. device:sub(2)
--         end, { 1 }),
--         ErrorCode = f(function(args)
--           return args[1][1] .. "SetError"
--         end, { 1 }),
--       }
--     )
--   )
-- )
--

table.insert(
  snippets.go,
  s(
    "gocreatefunc",
    fmt(
      [[
func (m *mysql{UserType}Model) Create(ctx context.Context, {userVar} model.{UserType}) error {{
    do := query.{UserType}.WithContext(ctx)
    if err := do.Create(&{userVar}); err != nil {{
        return errdefs.Unknown(ecode.Error(bizcode.InternalServerError, reasoncode.{ErrorCode}, err.Error()))
    }}
    return nil
}}
]],
      {
        UserType = i(1, "User"),
        userVar = f(function(args)
          local user = args[1][1]
          return user:sub(1, 1):lower() .. user:sub(2)
        end, { 1 }),
        ErrorCode = f(function(args)
          return args[1][1]:gsub("^%l", string.upper) .. "CreateError"
        end, { 1 }),
      }
    )
  )
)

return snippets
