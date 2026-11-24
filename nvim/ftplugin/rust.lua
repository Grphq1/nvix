if vim.fn.executable('rust-analyzer') ~= 1 then
  return
end

local lsp_utils = require('user.lsp')

vim.lsp.start {
  name = 'rust-analyzer',
  cmd = { 'rust-analyzer' },
  root_dir = lsp_utils.find_root_dir({
    'Cargo.toml',
    'Cargo.lock',
    'rust-project.json',
    '.git',
  }),
  capabilities = lsp_utils.make_client_capabilities(),
}
