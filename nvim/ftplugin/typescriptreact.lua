local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')
local unocss = require('user.unocss')

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
unocss.setup()
eslint.setup()
