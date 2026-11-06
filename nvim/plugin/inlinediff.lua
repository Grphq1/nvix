if vim.g.did_load_inlinediff then
  return
end
vim.g.did_load_inlinediff = true

local inline_diff = require("inlinediff")
inline_diff.setup {
  enabled = true,
  show_staged = true,
}

vim.keymap.set("n", "<leader>gi", function()
  inline_diff.toggle()
end, { noremap = true, silent = true, desc = "[g]it [i]nline diff toggle" })
