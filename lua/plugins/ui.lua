if false then
  return {}
end
return {
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
      mappings = {
        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[i",
        goto_bottom = "]i",
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    enabled = true,
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter", "luukvbaal/statuscol.nvim" },
    config = function()
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = false
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local line = vim.fn.getline(lnum)
        if line:find("if%s+err%s*!= nil") then
          local prevLine = vim.api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, false)[1]
          local indent = string.match(prevLine, "^%s*") or "" -- 获取上一行的缩进
          local startLine = lnum
          local endLine = endLnum
          local lines = vim.api.nvim_buf_get_lines(0, startLine, endLine - 1, false)
          for i, l in ipairs(lines) do
            lines[i] = l:gsub("^%s*", ""):gsub("return", "..") -- 去掉开头的空格
          end
          local newText = indent .. table.concat(lines, "; ")
          virtText = { { newText, "@comment" } }
          return virtText
        end
        if line:find("if%s+[^;]+;[^;]+!= nil") then
          local startLine = lnum
          local endLine = endLnum
          local lines = vim.api.nvim_buf_get_lines(0, startLine, endLine - 1, false)
          for i, l in ipairs(lines) do
            lines[i] = l:gsub("^%s*", "")
          end
          local content = table.concat(lines, "; ")

          local newVirtText = {}
          -- local suffix = ('  %d '):format(endLnum - lnum)
          local suffix = " ? " .. content
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          local errCount = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)

            if targetWidth > curWidth + chunkWidth then
              if chunkText == "err" then
                errCount = errCount + 1
                if errCount ~= 2 then
                  table.insert(newVirtText, { chunkText, chunk[2] })
                end
              end

              if
                chunkText ~= ";"
                and chunkText ~= "err"
                and chunkText ~= "!="
                and chunkText ~= "nil"
                and chunkText ~= "{"
                and chunkText ~= "if"
                and chunkText ~= " "
              then
                if chunkText == ":=" or chunkText == "=" then
                  chunkText = " " .. chunkText .. " "
                  table.insert(newVirtText, { chunkText, chunk[2] })
                elseif chunkText == "," then
                  chunkText = "," .. " "
                  table.insert(newVirtText, { chunkText, chunk[2] })
                else
                  table.insert(newVirtText, { chunkText, chunk[2] })
                end
              end
            end
            curWidth = curWidth + vim.fn.strdisplaywidth(chunkText)
          end
          table.insert(newVirtText, { suffix, "k.bracket" })
          return newVirtText
        end

        local newVirtText = {}
        local suffix = ("...%d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + vim.fn.strdisplaywidth(chunkText)
        end
        table.insert(newVirtText, { suffix, "k.bracket" })

        return newVirtText
      end

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        open_fold_hl_timeout = 150,
        close_fold_kinds_ft = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    event = "BufRead",
    config = function()
      local colors = {
        red = "#e965a5",
        green = "#b1f2a7",
        yellow = "#ebde76",
        blue = "#b1baf4",
        purple = "#e192ef",
        cyan = "#b3f4f3",
        white = "#eee9fc",
        black = "#282433",
        selection = "#282433",
        comment = "#938aad",
        bg = "#312c2b",
      }

      local hardhacker_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.green },
          b = { fg = colors.cyan, bg = colors.bg },
          c = { fg = colors.yellow, bg = colors.bg },
        },

        insert = { a = { fg = colors.black, bg = colors.red } },
        visual = { a = { fg = colors.black, bg = colors.yellow } },
        replace = { a = { fg = colors.black, bg = colors.red } },

        inactive = {
          a = { fg = colors.white, bg = colors.selection },
          b = { fg = colors.white, bg = colors.selection },
          c = { fg = colors.white, bg = colors.selection },
        },

        command = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.cyan, bg = colors.selection },
          c = { fg = colors.yellow, bg = colors.selection },
        },
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          -- theme = hardhacker_theme,
          theme = "dracula",
          -- component_separators = { left = "░", right = "░" },
          component_separators = "|",
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = "                                    " },
              right_padding = 2,
            },
          },
          lualine_b = {
            { "branch" },
            { "diff" },
          },
          lualine_c = {
            {
              "filename",
              file_status = true, -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 1, -- 0: Just the filename
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory

              shorting_target = 70, -- Shortens path to leave 40 spaces in the window
              -- for other components. (terrible name, any suggestions?)
              symbols = {
                modified = "[+]", -- Text to show when the file is modified.
                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                unnamed = "[No Name]", -- Text to show for unnamed buffers.
                newfile = "[New]", -- Text to show for newly created file before first write
              },
            },
          },
          lualine_x = {
            {
              require("noice").api.status.command.get,
              cond = require("noice").api.status.command.has,
              color = { fg = colors.yellow },
            },
            {
              require("noice").api.status.search.get,
              cond = require("noice").api.status.search.has,
              color = { fg = colors.yellow },
            },
            "encoding",
            "fileformat",
            "filetype",
            "filesize",
          },
          lualine_y = {
            "progress",
            {
              "diagnostics",

              -- Table of diagnostic sources, available sources are:
              --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
              -- or a function that returns a table as such:
              --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
              sources = { "nvim_lsp", "nvim_diagnostic" },

              -- Displays diagnostics for the defined severity types
              sections = { "error", "warn", "info", "hint" },

              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = "DiagnosticError", -- Changes diagnostics' error color.
                warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                info = "DiagnosticInfo", -- Changes diagnostics' info color.
                hint = "DiagnosticHint", -- Changes diagnostics' hint color.
              },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
          },
          lualine_z = {
            {
              "location",
              separator = { right = "                                  " },
              left_padding = 2,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
           ██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
           ╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
            ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
             ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
              ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
              ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        -- theme = "hyper",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- week_header = {
          --   enable = true,
          -- },
          -- packages = { enabled = true },

          -- stylua: ignore
          center = {
            { action = LazyVim.telescope("files"),                                 desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                                        desc = " New File",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                                       desc = " Recent Files",    icon = " ", key = "r" },
            { action = "Telescope projects",                                       desc = " Projects",        icon = " ", key = "p" },
            { action = "Telescope live_grep",                                      desc = " Find Text",       icon = " ", key = "g" },
            { action = [[lua LazyVim.telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    version = "^1",
    enabled = true,
    event = "VeryLazy",
  },
}
