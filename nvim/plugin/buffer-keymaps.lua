-- Buffer navigation (bufferline)
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer', silent = true })

-- Jump to buffer by position (like browser tabs)
vim.keymap.set('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Buffer 1', silent = true })
vim.keymap.set('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<CR>', { desc = 'Buffer 2', silent = true })
vim.keymap.set('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<CR>', { desc = 'Buffer 3', silent = true })
vim.keymap.set('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<CR>', { desc = 'Buffer 4', silent = true })
vim.keymap.set('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<CR>', { desc = 'Buffer 5', silent = true })

-- Buffer deletion (nvim-bufdel) - integrates with your existing setup
vim.keymap.set('n', '<leader>bd', '<cmd>BufDel<CR>', { desc = '[b]uffer [d]elete', silent = true })
vim.keymap.set('n', '<leader>bD', '<cmd>BufDel!<CR>', { desc = '[b]uffer [D]elete (force)', silent = true })

-- Delete all other buffers (keep current)
vim.keymap.set('n', '<leader>bo', '<cmd>BufDelOthers<CR>', { desc = '[b]uffer delete [o]thers', silent = true })

-- Quick close (alternative to :q) - doesn't conflict with your <C-c> quickfix toggle
vim.keymap.set('n', '<C-x>', '<cmd>BufDel<CR>', { desc = 'Close buffer', silent = true })

-- Buffer picking (bufferline feature - interactive selection)
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = '[b]uffer [p]ick', silent = true })

-- Move buffers left/right in the bufferline
vim.keymap.set('n', '<leader>b<', '<cmd>BufferLineMovePrev<CR>', { desc = 'Move buffer left', silent = true })
vim.keymap.set('n', '<leader>b>', '<cmd>BufferLineMoveNext<CR>', { desc = 'Move buffer right', silent = true })

-- Pin/unpin buffer (bufferline feature)
vim.keymap.set('n', '<leader>bP', '<cmd>BufferLineTogglePin<CR>', { desc = '[b]uffer toggle [P]in', silent = true })

-- Close all buffers to the right/left
vim.keymap.set(
  'n',
  '<leader>bcr',
  '<cmd>BufferLineCloseRight<CR>',
  { desc = '[b]uffer [c]lose [r]ight', silent = true }
)
vim.keymap.set('n', '<leader>bcl', '<cmd>BufferLineCloseLeft<CR>', { desc = '[b]uffer [c]lose [l]eft', silent = true })

-- Your existing telescope buffer picker is at <leader>tbb - keep using it!
