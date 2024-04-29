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
snippets.all = {}

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
    {1}Model interface {{
        Set(ctx context.Context, data {2}) error
    }}

    {3} struct {{
        Model
    }}
)

func (p *{4}) TableName() string {{
    return "{table_name}s"
}}
]],
      {
        i(1, "StructName"),
        rep(1),
        rep(1),
        rep(1),
        -- i(2, "table_name"),
        table_name = f(function(args)
          local name = args[1][1]
          return name:sub(1, 1):lower() .. name:sub(2)
        end, { 1 }),
      }
    )
  )
)

table.insert(
  snippets.go,
  s(
    "mysqlmodel",
    fmt(
      [[
package mysql

type mysql{1}Model struct {{
    db *gorm.DB
}}

func New{2}Model(db *gorm.DB) model.{3}Model {{
    return &mysql{4}Model{{
        db: db,
    }}
}}

func (m *mysql{5}Model) Create(ctx context.Context, {name} model.{6}) error {{
    do := query.{7}.WithContext(ctx)
    if err := do.Create(&{8}); err != nil {{
        return errdefs.Unknown(ecode.Error(bizcode.InternalServerError, reasoncode.{9}CreateError, err.Error()))
    }}
    return nil
}}
]],
      {
        i(1, "Device"),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        rep(1),
        name = f(function(args)
          local name = args[1][1]
          return name:sub(1, 1):lower() .. name:sub(2)
        end, { 1 }),
      }
    )
  )
)
return snippets
