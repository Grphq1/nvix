local M = {}

local lsp = require('user.lsp')

local root_markers = {
  'uno.config.js',
  'uno.config.ts',
  'unocss.config.js',
  'unocss.config.ts',
}

function M.setup()
  local root_dir = lsp.find_root_dir(root_markers, nil, true)

  if not root_dir then
    return
  end

  local cmd = vim.fn.exepath('unocss-language-server')

  if cmd == '' then
    return
  end

  vim.lsp.start {
    name = 'unocss',
    cmd = { cmd, '--stdio' },
    root_dir = root_dir,

    settings = {
      unocss = {},
    },
  }
end

return M
