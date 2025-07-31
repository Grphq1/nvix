-- nvim/lua/user/conform.lua
local conform = require('conform')

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    vue = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    markdown = { "prettier" },
    lua = { "stylua" },
    nix = { "alejandra" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

vim.keymap.set('n', '<space>f', function()
  conform.format({ async = true })
end, { desc = "Format buffer with Prettier" })
