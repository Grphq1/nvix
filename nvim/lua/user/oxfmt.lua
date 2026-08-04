local M = {}

local lsp = require('user.lsp')

M.filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'toml',
  'json',
  'jsonc',
  'json5',
  'yaml',
  'html',
  'vue',
  'handlebars',
  'css',
  'scss',
  'less',
  'graphql',
  'markdown',
  'svelte',
}

local root_markers = {
  '.oxfmtrc.json',
  '.oxfmtrc.jsonc',
  'oxfmt.config.ts',
}

M.cmd = function(dispatchers, config)
  local cmd = 'oxfmt'

  if (config or {}).root_dir then
    local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
  end

  return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
end

M.setup = function()
  local root_dir = lsp.find_root_dir(root_markers, nil, true)

  if not root_dir then
    return
  end

  vim.lsp.start {
    name = 'oxfmt',
    cmd = M.cmd,
    filetypes = M.filetypes,
    root_dir = root_dir,
    workspace_required = true,
  }
end

return M
