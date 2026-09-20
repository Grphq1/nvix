if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Fall back to find_files if not in a git repo
local project_files = function()
  local ok = pcall(builtin.git_files, {})
  if not ok then
    builtin.find_files({})
  end
end

vim.keymap.set('n', '<leader>tp', project_files, { desc = '[t]elescope [p]roject files' })
vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = '[t]elescope [f]ind files' })
vim.keymap.set('n', '<leader>tg', builtin.live_grep, { desc = '[t]elescope [g]rep' })
vim.keymap.set('n', '<leader>tb', builtin.buffers, { desc = '[t]elescope [b]uffers' })
vim.keymap.set('n', '<leader>tr', builtin.oldfiles, { desc = '[t]elescope [r]ecent files' })

telescope.setup {
  defaults = {
    path_display = { 'truncate' },
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.9,
      height = 0.8,
      preview_width = 0.55,
    },
    prompt_prefix = '   ',
    selection_caret = ' › ',
    initial_mode = 'insert',
    color_devicons = true,
  },
}

pcall(telescope.load_extension, 'fzy_native')
