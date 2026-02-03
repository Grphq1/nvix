local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')
local unocss = require('user.unocss')
local lsp_utils = require('user.lsp')

vim.lsp.start {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = lsp_utils.find_root_dir({
    'tsconfig.json',
    'package.json',
    'jsconfig.json',
  }),
  capabilities = lsp_utils.make_client_capabilities(),
}
tailwindcss.setup()
unocss.setup()
eslint.setup()
