local M = {}

M.setup = function()
  vim.lsp.start {
    name = 'tailwindcss',
    cmd = { 'tailwindcss-language-server', '--stdio' },
    root_dir = require('user.lsp').find_root_dir({
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts'
    }),
    settings = {
      tailwindCSS = {
        classFunctions = { 'cva', 'clsx', 'cv' },
        validate = true,
        lint = {
          cssConflict = 'warning',
          invalidApply = 'error',
          invalidScreen = 'error',
          invalidVariant = 'error',
          invalidConfigPath = 'error',
          invalidTailwindDirective = 'error',
          recommendedVariantOrder = 'warning',
        },
        classAttributes = {
          'class',
          'className',
          'class:list',
          'classList',
          'ngClass',
        },
        includeLanguages = {
          eelixir = 'html-eex',
          eruby = 'erb',
          templ = 'html',
          htmlangular = 'html',
        },
      },
    },
  }
end

return M
