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

return {
  all = {
    s(
      {
        trig = "gomysqlmodel",
        dscr = "go mysql 代码实现",
      },
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
          i(1, "User"),
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
    ),

    s(
      "gomodel",
      fmt(
        [[
package model

import "context"

type (
    {1}Model interface {{
        Set(ctx context.Context, {2} {3}) error
    }}

    {4} struct {{
        Model
    }}
)

func (p *{5}) TableName() string {{
    return "{6}s"
}}
]],
        {
          i(1, "StructName"),
          f(function(args)
            local name = args[1][1]
            return name:sub(1, 1):lower() .. name:sub(2)
          end, { 1 }),
          rep(1),
          rep(1),
          rep(1),
          f(function(args)
            local name = args[1][1]
            return name:sub(1, 1):lower() .. name:sub(2)
          end, { 1 }),
        }
      )
    ),
  },
}
