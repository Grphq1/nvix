--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.start {
  capabilities = capabilities,
  name = "css_ls",
  cmd = { "vscode-css-language-server", "--stdio" },
  init_options = {
    provideFormatter = true
  },
  root_dir = vim.fs.dirname(vim.fs.find({
    "package.json",
    ".git"
  }, { upward = true })[1]),
  settings = {
    css = {
      validate = true
    },
    less = {
      validate = true
    },
    scss = {
      validate = true
    }
  },
}
