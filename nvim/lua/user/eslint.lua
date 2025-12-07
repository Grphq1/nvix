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

M.setup = function()
  vim.lsp.start {
    name = 'eslint',
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    on_attach = function(client, bufnr)
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds { group = 'EslintFixAll', buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = 'EslintFixAll',
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format {
              bufnr = bufnr,
              filter = function(c)
                return c.name == 'eslint'
              end,
              timeout_ms = 5000,
              async = false,
            }
          end,
        })
      end
    end,
    root_dir = vim.fs.dirname(vim.fs.find({
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.json',
      '.eslintrc.yml',
      '.eslintrc.yaml',
      'eslint.config.js',
    }, { upward = true })[1]) or vim.loop.cwd(),
    settings = {
      rulesCustomizations = customizations,

      codeAction = {
        disableRuleComment = { enable = true, location = 'separateLine' },
        showDocumentation = { enable = true },
      },
      codeActionOnSave = { enable = true, mode = 'all' },
      experimental = { useFlatConfig = false },
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
