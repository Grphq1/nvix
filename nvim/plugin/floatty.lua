if vim.g.did_load_floatty_plugin then
  return
end
vim.g.did_load_floatty_plugin = true

local term = require('floatty').setup {
  window = {
    height = function()
      return vim.o.lines - 3
    end,
    h_align = 'right',
    width = 0.33,
  },
}

local lazygit = require('floatty').setup {
  cmd = 'lazygit',
}

vim.keymap.set('n', '<C-t>', function()
  term.toggle()
end)

vim.keymap.set('t', '<C-t>', function()
  term.toggle()
end)

vim.keymap.set('n', '<C-l>', function()
  lazygit.toggle()
end)

vim.keymap.set('t', '<C-l>', function()
  lazygit.toggle()
end)
