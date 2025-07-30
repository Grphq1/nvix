if vim.g.did_load_bufferline_plugin then
  return
end

vim.g.did_load_bufferline_plugin = true

vim.opt.termguicolors = true
vim.o.mousemoveevent = true

require("bufferline").setup({
  options = {
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' }
    }
  }
})
