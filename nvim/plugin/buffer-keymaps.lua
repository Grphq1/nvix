-- Buffer navigation (bufferline)
-- Use built-in tabpages for navigation
vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer', silent = true })

vim.keymap.set('n', '<leader>bd', '<cmd>BufDel<CR>', { desc = '[b]uffer [d]elete', silent = true })
vim.keymap.set('n', '<leader>bD', '<cmd>BufDel!<CR>', { desc = '[b]uffer [D]elete (force)', silent = true })

-- Delete all other buffers (keep current)
vim.keymap.set('n', '<leader>bo', '<cmd>BufDelOthers<CR>', { desc = '[b]uffer delete [o]thers', silent = true })

-- Quick close (alternative to :q) - doesn't conflict with your <C-c> quickfix toggle
vim.keymap.set('n', '<C-x>', '<cmd>BufDel<CR>', { desc = 'Close buffer', silent = true })
