local eslint = require('user.lsp.eslint')

vim.lsp.start {
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = vim.fs.dirname(vim.fs.find({
    "tsconfig.json",
    "package.json",
    "jsconfig.json",
  }, { upward = true })[1]),
}

eslint.setup()
