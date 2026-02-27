if vim.g.did_load_focus_plugin then
  return
end
vim.g.did_load_focus_plugin = true

require('focus').setup()

local focusmap = function(direction)
  vim.keymap.set('n', '<Leader>' .. direction, function()
    require('focus').split_command(direction)
  end, { desc = string.format('Create or move to split (%s)', direction) })
end

focusmap('h')
focusmap('j')
focusmap('k')
focusmap('l')
