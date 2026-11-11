if vim.g.did_load_grapple then
  return
end
vim.g.did_load_grapple = true

local grapple = require('grapple')
grapple.setup {}

-- keybindings
vim.keymap.set("n", "<leader>m", function()
  grapple.toggle()
  vim.cmd("redrawtabline")
end)
vim.keymap.set("n", "<leader>M", grapple.toggle_tags)

-- cycle through tags
vim.keymap.set("n", "<leader>n", grapple.cycle_forward)
vim.keymap.set("n", "<leader>N", grapple.cycle_backward)

-- quick select by number (space + 1, space + 2, ...)
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    grapple.select({ index = i })
  end, { desc = "Grapple select tag " .. i })
end
