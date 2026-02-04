if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

-- nvim-treesitter-textobjects

-- select
vim.keymap.set({ 'x', 'o' }, 'af', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'if', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
end, {})
vim.keymap.set({ 'x', 'o' }, 'as', function()
  require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
end, {})

-- swap
vim.keymap.set('n', '<leader>a', function()
  require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
end, {})
vim.keymap.set('n', '<leader>A', function()
  require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
end, {})

-- move
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
end, { desc = '[m] next function (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
end, { desc = '[M] next function (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
  require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
end, { desc = '[p] next parameter (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
  require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
end, { desc = '[P] next parameter (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
end, { desc = '[m] previous function (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
end, { desc = '[M] previous function (end)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
  require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
end, { desc = 'previous [p]arameter (start)' })
vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
  require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
end, { desc = 'previous [P]arameter (end)' })

require('treesitter-context').setup {
  max_lines = 3,
}

require('ts_context_commentstring').setup()

