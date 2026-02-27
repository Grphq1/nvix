if vim.g.did_load_tabline_framework_plugin then
  return
end
vim.g.did_load_tabline_framework_plugin = true

vim.o.showtabline = 2

local render = function(f)
  f.add ' '

  local cur_buf = vim.api.nvim_get_current_buf()
  local severity = vim.diagnostic.severity

  local function diagnostics_count(bufnr, level)
    return #vim.diagnostic.get(bufnr, { severity = level })
  end

  f.make_bufs(function(info)
    local mark = info.buf == cur_buf and '*' or ' '
    f.add(' ' .. mark .. ' ' .. info.buf .. ' ')

    if info.filename then
      if info.modified then
        f.add '+'
      end
      f.add(info.filename)
    else
      f.add(info.modified and '[+]' or '[no name]')
    end

    f.add ' '
  end)

  local errors = diagnostics_count(cur_buf, severity.ERROR)
  local warns = diagnostics_count(cur_buf, severity.WARN)
  local infos = diagnostics_count(cur_buf, severity.INFO)
  local hints = diagnostics_count(cur_buf, severity.HINT)

  if errors + warns + infos + hints > 0 then
    f.add '%='
    f.add('E:' .. errors .. ' W:' .. warns .. ' I:' .. infos .. ' H:' .. hints .. ' ')
  end
end

vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'NONE', underline = false })

require('tabline_framework').setup {
  render = render,
}
