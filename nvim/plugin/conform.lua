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
  },
}

vim.keymap.set('n', '<space>f', function()
  conform.format {
    async = true,
  }
end, {
  desc = 'Format buffer',
})
