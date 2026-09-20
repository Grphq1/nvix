if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local severity = diagnostic.severity

local QF_HEIGHT = 3

local function fmt_diag(d)
  return (d.source and ('[' .. d.source .. '] ') or '') .. (d.message or '')
end

local function qf_win()
  local w = fn.getqflist({ winid = 0 }).winid
  return (w ~= 0 and api.nvim_win_is_valid(w)) and w or nil
end

local function refresh_qf()
  diagnostic.setqflist({
    open = false,
    title = 'Diagnostics',
    format = fmt_diag,
  })
end

local function fit_qf_height()
  local winid = qf_win()
  if not winid then return end
  vim.wo[winid].winfixheight = true
  vim.wo[winid].winfixwidth  = true
  if api.nvim_win_get_height(winid) ~= QF_HEIGHT then
    api.nvim_win_set_height(winid, QF_HEIGHT)
  end
end

local function toggle_qf()
  if qf_win() then
    vim.cmd.cclose()
    return
  end
  refresh_qf()
  local cur_win = api.nvim_get_current_win()
  vim.cmd('keepalt botright copen ' .. QF_HEIGHT)
  if api.nvim_win_is_valid(cur_win) then
    api.nvim_set_current_win(cur_win)
  end
  vim.schedule(fit_qf_height)
end

keymap.set('n', '<leader>qft', toggle_qf, { desc = 'Toggle diagnostics' })

keymap.set('n', '<leader>qff', function()
  local w = qf_win()
  if not w then
    vim.notify('diagnostics window is not open', vim.log.levels.INFO)
    return
  end
  if api.nvim_get_current_win() == w then
    vim.cmd.wincmd 'p'
  else
    api.nvim_set_current_win(w)
  end
end, { desc = 'Focus diagnostics' })


api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function()
    vim.schedule(function()
      if qf_win() then
        refresh_qf()
        fit_qf_height()
      end
    end)
  end,
})

api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.schedule(fit_qf_height)
  end,
})

api.nvim_create_autocmd('WinResized', {
  callback = function()
    if qf_win() then
      vim.schedule(fit_qf_height)
    end
  end,
})


keymap.set('n', '[d', diagnostic.goto_prev, { desc = 'previous [d]iagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { desc = 'next [d]iagnostic' })

keymap.set('n', '[e', function()
  diagnostic.goto_prev { severity = severity.ERROR }
end, { desc = 'previous [e]rror diagnostic' })
keymap.set('n', ']e', function()
  diagnostic.goto_next { severity = severity.ERROR }
end, { desc = 'next [e]rror diagnostic' })

keymap.set('n', '[w', function()
  diagnostic.goto_prev { severity = severity.WARN }
end, { desc = 'previous [w]arning diagnostic' })
keymap.set('n', ']w', function()
  diagnostic.goto_next { severity = severity.WARN }
end, { desc = 'next [w]arning diagnostic' })

keymap.set('n', '[h', function()
  diagnostic.goto_prev { severity = severity.HINT }
end, { desc = 'previous [h]int diagnostic' })
keymap.set('n', ']h', function()
  diagnostic.goto_next { severity = severity.HINT }
end, { desc = 'next [h]int diagnostic' })

keymap.set('n', '<space>e', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  api.nvim_win_set_config(winid, { focusable = true })
end, { desc = 'diagnostics floating window' })

keymap.set('n', '<space>dt', function()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end, { desc = 'toggle diagnostics (buffer)' })


keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<leader>S', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end, { desc = 'toggle [S]pell' })


keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'move DOWN [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'move UP full-page and center' })

keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'open netrw' })
