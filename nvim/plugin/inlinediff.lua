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

-- staging/unstaging changes the index, not the buffer, so no TextChanged fires
vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  callback = function(args)
    inline_diff.refresh(args.data and args.data.buffer)
  end,
})
