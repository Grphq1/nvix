local conform = require('conform')

conform.setup {
  formatters_by_ft = {
    javascript = { 'oxfmt', 'prettier', stop_after_first = true },
    javascriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    typescript = { 'oxfmt', 'prettier', stop_after_first = true },
    typescriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    vue = { 'oxfmt', 'prettier' },

    css = { 'oxfmt', 'prettier', stop_after_first = true },
    scss = { 'oxfmt', 'prettier', stop_after_first = true },
    markdown = { 'prettier' },

    lua = { 'stylua' },
    nix = { 'alejandra' },
    rust = { 'rustfmt' },
    tex = { 'tex-fmt' },
  },
}

vim.keymap.set('n', '<space>f', function()
  if vim.bo.filetype == 'vue' and require('user.eslint').formats_with_lint(0) then
    vim.lsp.buf.format { name = 'eslint', async = true }
    return
  end

  conform.format {
    async = true,
  }
end, {
  desc = 'Format buffer',
})
