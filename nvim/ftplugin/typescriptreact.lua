local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')

vim.lsp.start {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.dirname(vim.fs.find({
    'tsconfig.json',
    'package.json',
    'jsconfig.json',
  }, { upward = true })[1]),
}
tailwindcss.setup()
eslint.setup()
