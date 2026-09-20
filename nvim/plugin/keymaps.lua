if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_diagnostics()
  local loclist_win = vim.fn.getloclist(0, { winid = 0 }).winid
  if loclist_win ~= 0 then
    vim.cmd.lclose()
    return
  end

  vim.diagnostic.setloclist({
    open = true,
    title = 'Diagnostics',
    format = function(d)
      local source = d.source and ('[' .. d.source .. '] ') or ''
      local code = d.code and ('(' .. d.code .. ') ') or ''
      return source .. code .. d.message
    end,
  })
end

vim.keymap.set('n', '<C-c>', toggle_diagnostics, { desc = 'Toggle diagnostics (loclist)' })


-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

local severity = diagnostic.severity

keymap.set('n', '<space>e', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  if not winid then
    vim.notify('no diagnostics found', vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next [d]iagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'previous [e]rror diagnostic' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'next [e]rror diagnostic' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'previous [w]arning diagnostic' })
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'next [w]arning diagnostic' })
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'previous [h]int diagnostic' })
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'next [h]int diagnostic' })

local function buf_toggle_diagnostics()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<space>dt', buf_toggle_diagnostics)

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move [d]own half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move [u]p half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'move DOWN [f]ull-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'move UP full-page and center' })

keymap.set('n', '<leader>pv', vim.cmd.Ex)
