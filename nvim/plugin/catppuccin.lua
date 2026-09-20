if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin = true

require('catppuccin').setup {
  flavour = 'auto', -- latte, frappe, macchiato, mocha
  background = { light = 'latte', dark = 'mocha' },
  transparent_background = true,
  float = {
    transparent = true,
    solid = true,
  },
  styles = {
    comments = { 'italic' },
    conditionals = { 'italic' },
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    treesitter = true,
    telescope = true,
  }
}

-- setup must be called before loading
vim.cmd.colorscheme('catppuccin-nvim')
