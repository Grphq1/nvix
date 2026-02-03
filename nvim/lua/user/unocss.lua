local M = {}

M.setup = function()
  vim.lsp.start {
    name = 'unocss',
    -- prefer system binary, fall back to the built Nix store path
    cmd = (function()
      local bin = vim.fn.exepath('unocss-language-server')
      if bin == '' then
        bin = '/nix/store/8h2hhjx3vk9r56f06pal8wkl6nv85cql-unocss-language-server-0.1.8/bin/unocss-language-server'
      end
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
