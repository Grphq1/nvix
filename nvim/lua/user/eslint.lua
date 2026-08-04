local M = {}

local lsp = require('user.lsp')

local customizations = {
  { rule = 'style/*', severity = 'off', fixable = true },
  { rule = 'format/*', severity = 'off', fixable = true },
  { rule = '*-indent', severity = 'off', fixable = true },
  { rule = '*-spacing', severity = 'off', fixable = true },
  { rule = '*-spaces', severity = 'off', fixable = true },
  { rule = '*-order', severity = 'off', fixable = true },
  { rule = '*-dangle', severity = 'off', fixable = true },
  { rule = '*-newline', severity = 'off', fixable = true },
  { rule = '*quotes', severity = 'off', fixable = true },
  { rule = '*semi', severity = 'off', fixable = true },
}

local base_on_attach = vim.lsp.config.eslint.on_attach

local eslint_root_markers = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.json',
  '.eslintrc.yml',
  '.eslintrc.yaml',
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
}

M.setup = function()
  local root_dir = lsp.find_root_dir(eslint_root_markers, nil, true)

  if not root_dir then
    return
  end

  local is_antfu = false

  local package_root = lsp.find_root_dir({ 'package.json' }, root_dir, true)

  if package_root then
    local path = vim.fs.joinpath(package_root, 'package.json')

    if vim.fn.filereadable(path) == 1 then
      local ok, package = pcall(
        vim.json.decode,
        table.concat(vim.fn.readfile(path), '\n')
      )

      if ok and type(package) == 'table' then
        local deps = vim.tbl_extend(
          'force',
          package.dependencies or {},
          package.devDependencies or {},
          package.peerDependencies or {}
        )

        is_antfu = deps['@antfu/eslint-config'] ~= nil
      end
    end
  end

  local settings = {
    format = true,
    nodePath = '',
    onIgnoredFiles = 'off',

    problems = {
      shortenToSingleLine = false,
    },

    quiet = false,
    run = 'onType',
    useESLintClass = false,
    validate = 'on',

    workingDirectory = {
      mode = 'location',
    },
  }

  if is_antfu then
    settings.experimental = {
      useFlatConfig = true,
    }

    settings.rulesCustomizations = customizations

    settings.codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },

      showDocumentation = {
        enable = true,
      },
    }

    settings.codeActionOnSave = {
      enable = false,
      mode = 'all',
    }
  end

  vim.lsp.start {
    name = 'eslint',
    cmd = { 'vscode-eslint-language-server', '--stdio' },

    root_dir = root_dir,

    on_attach = function(client, bufnr)
      if base_on_attach then
        base_on_attach(client, bufnr)
      end

      if is_antfu then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          command = 'LspEslintFixAll',
        })
      end
    end,

    settings = settings,
  }
end

return M
