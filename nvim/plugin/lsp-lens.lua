if vim.g.did_load_lsp_lens then
  return
end
vim.g.did_load_lsp_lens = true

local lsp_lens = require("lsp-lens")
lsp_lens.setup {}
