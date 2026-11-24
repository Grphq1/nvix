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

local nuxt_configs = {
  'nuxt.config.js',
  'nuxt.config.ts',
  'nuxt.config.mjs',
  'nuxt.config.cjs',
  'nuxt.config.mts',
  'nuxt.config.cts',
}

--- Whether the project's ESLint config already handles formatting (stylistic
--- or antfu rules, or a Nuxt config), so ESLint should be used as the formatter.
---@param bufnr? integer
---@return boolean
function M.formats_with_lint(bufnr)
  bufnr = bufnr or 0

  if not vim.lsp.get_clients({ bufnr = bufnr, name = 'eslint' })[1] then
    return false
  end

  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if dir == '' then
    dir = vim.fn.getcwd()
  end

  if vim.fs.find(nuxt_configs, { path = dir, upward = true })[1] then
    return true
  end

  local config = vim.fs.find(eslint_root_markers, { path = dir, upward = true })[1]
  if not config then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, config)
  if not ok then
    return false
  end

  local text = table.concat(lines, '\n'):lower()
  return text:find('stylistic', 1, true) ~= nil
    or text:find('antfu', 1, true) ~= nil
end

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
