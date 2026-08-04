local M = {}

local lsp = require('user.lsp')

local root_markers = {
  'tailwind.config.js',
  'tailwind.config.cjs',
  'tailwind.config.mjs',
  'tailwind.config.ts',
}

M.setup = function()
  local root_dir = lsp.find_root_dir(root_markers, nil, true)

  if not root_dir then
    return
  end

  local package_root = lsp.find_root_dir({ 'package.json' }, root_dir, true)
  if package_root then
    local path = vim.fs.joinpath(package_root, 'package.json')
    if vim.fn.filereadable(path) == 1 then
      local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
      if ok and type(package) == 'table' then
        local deps = vim.tbl_extend('force', package.dependencies or {}, package.devDependencies or {}, package.peerDependencies or {})
        if not deps['tailwindcss'] then
          return
        end
      end
    end
  end

  if vim.fn.executable('tailwindcss-language-server') == 0 then
    return
  end

  vim.lsp.start {
    name = 'tailwindcss',
    cmd = { 'tailwindcss-language-server', '--stdio' },
    root_dir = root_dir,

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
