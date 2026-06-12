if vim.g.did_load_luasnip_plugin then
  return
end
vim.g.did_load_luasnip_plugin = true

local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

-- Optional: load your own snippets from ~/.config/nvim/snippets/
-- require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
-- require('luasnip.loaders.from_lua').lazy_load({ paths = { vim.fn.stdpath('config') .. '/luasnippets' } })

luasnip.config.set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}
