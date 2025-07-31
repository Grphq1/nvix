local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.start {
capabilities = capabilities,
  name = "html_ls",
  cmd = { "vscode-html-language-server", "--stdio" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    provideFormatter = true
  },
  root_dir = vim.fs.dirname(vim.fs.find({
    "package.json",
    ".git"
  }, { upward = true })[1]),
  settings = {},
}
