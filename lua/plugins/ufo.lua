return {
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
        if line:find(".+,%s+err%s*[:=]+%s+.+%([^%)]*%)") then
          local lines = vim.api.nvim_buf_get_lines(0, lnum + 1, endLnum, false)
          for i, l in ipairs(lines) do
            lines[i] = l:gsub("^%s*", "")
          end
          local newText = table.concat(lines, "; "):gsub([[; }]], " ")
          local suffix = " ? " .. newText
          local totalWidth = vim.fn.winwidth(0) -- 获取当前窗口的宽度
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local maxSuffixLength = totalWidth - 10 -- 为其他文本保留一些空间
          if sufWidth > maxSuffixLength then
            suffix = suffix:sub(1, maxSuffixLength - 3) .. "..."
          end
          local newVirtText = {}
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if totalWidth > chunkWidth then
              table.insert(newVirtText, chunk)
            else
              break -- 停止添加文本，如果没有更多空间
            end
          end

          table.insert(newVirtText, { suffix, "k.bracket" })
          return newVirtText
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

              if chunkText ~= ";" and chunkText ~= "err" and chunkText ~= "!=" and chunkText ~= "nil" and chunkText ~= "{" and chunkText ~= "if" and chunkText ~= " " then
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

      local function get_error_handling_folds(bufnr)
        local error_folds = {}
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local is_in_error_block = false
        local error_block_start = 0

        for i = 0, line_count - 1 do
          local line = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)[1]
          -- 检查是否是错误处理开始的行，即包含 'err =' 或 'err :='
          if not is_in_error_block and line:match(".+,%s+err%s*[:=]+%s+.+%([^%)]*%)") then
            is_in_error_block = true
            error_block_start = i
          -- 检查是否是错误处理块的结束行，即包含 '}'
          elseif is_in_error_block and line:match("%s*}") then
            is_in_error_block = false
            table.insert(error_folds, { startLine = error_block_start, endLine = i })
          end
        end

        -- 如果文件结束时仍然处于错误处理块中，将其添加到结果中
        if is_in_error_block then
          table.insert(error_folds, { startLine = error_block_start, endLine = line_count - 1 })
        end

        return error_folds
      end

      local ftMap = {
        go = function(bufnr)
          local err_folds = get_error_handling_folds(bufnr)
          local lsp_folds = require("ufo").getFolds(bufnr, "treesitter")
          for _, fold in ipairs(err_folds) do
            table.insert(lsp_folds, fold)
          end
          -- print(vim.inspect(lsp_folds))
          return lsp_folds
        end,
      }

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return ftMap[filetype] or { "treesitter", "indent" }
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
}
