local M = {}

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
M.setup = function()
  vim.lsp.start {
    name = 'eslint',
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    on_attach = function(client, bufnr)
      if not base_on_attach then
        return
      end

      base_on_attach(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'LspEslintFixAll',
      })
    end,
    root_dir = require('user.lsp').find_root_dir({
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.json',
      '.eslintrc.yml',
      '.eslintrc.yaml',
      'eslint.config.js',
    }),
    settings = {
      rulesCustomizations = customizations,
      codeAction = {
        disableRuleComment = { enable = true, location = 'separateLine' },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      experimental = { useFlatConfig = true },
      format = true,
      nodePath = '',
      onIgnoredFiles = 'off',
      problems = { shortenToSingleLine = false },
      quiet = false,
      run = 'onType',
      useESLintClass = false,
      validate = 'on',
      workingDirectory = { mode = 'location' },
    },
  }
end

return M
