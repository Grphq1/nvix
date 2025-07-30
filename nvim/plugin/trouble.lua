if vim.g.did_load_trouble_plugin then
  return
end

vim.g.did_load_trouble_plugin = true

local trouble = require("trouble")
trouble.setup({
  auto_close = true,
  auto_jump = true,
  modes = {
    diagnostics = { auto_open = true },
  }
})

local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Trouble" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Document Diagnostics" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })


map("n", "]d", function()
  trouble.next({ skip_groups = true, jump = true })
end, { desc = "Next Diagnostic" })

map("n", "[d", function()
  trouble.prev({ skip_groups = true, jump = true })
end, { desc = "Previous Diagnostic" })
