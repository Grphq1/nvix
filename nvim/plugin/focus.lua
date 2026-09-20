if vim.g.did_load_focus_plugin then
  return
end
vim.g.did_load_focus_plugin = true

require('focus').setup {}

local ignore_filetypes = { 'qf', 'help', 'man', 'lspinfo' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup', 'quickfix' }

local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
  group = augroup,
  callback = function()
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) or vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = 'Disable focus autoresize for special windows',
})

local focusmap = function(direction)
  vim.keymap.set('n', '<Leader>' .. direction, function()
    require('focus').split_command(direction)
  end, { desc = string.format('Create or move to split (%s)', direction) })
end

focusmap('h')
focusmap('j')
focusmap('k')
focusmap('l')
