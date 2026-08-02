local M = {}

M.setup = function()
  vim.lsp.start {
    name = 'unocss',
    -- prefer system binary, fall back to the built Nix store path
    cmd = (function()
      local bin = vim.fn.exepath('unocss-language-server')
      return { bin, '--stdio' }
    end)(),
    root_dir = require('user.lsp').find_root_dir({
      'uno.config.js',
      'uno.config.ts',
      'unocss.config.js',
      'unocss.config.ts',
    }),
    settings = {
      unocss = {
        -- Optional settings can be added here based on what the language server supports
      },
    },
  }
end

return M
