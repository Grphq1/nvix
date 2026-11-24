if vim.fn.executable('texlab') ~= 1 then
  return
end

local lsp_utils = require('user.lsp')

vim.lsp.start {
  name = 'texlab',
  cmd = { 'texlab' },
  root_dir = lsp_utils.find_root_dir({
    '.latexmkrc',
    'latexmkrc',
    'Tectonic.toml',
    '.git',
  }),
  capabilities = lsp_utils.make_client_capabilities(),
}
