if vim.g.did_load_nvim_tree_plugin then
  return
end

vim.g.did_load_nvim_tree_plugin = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match('NvimTree') then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
    end)
  end,
})

require('nvim-tree').setup {
  sync_root_with_cwd = false,
  respect_buf_cwd = false,
  update_focused_file = {
    enable = true,
    update_root = false,
  },

  renderer = {
    root_folder_label = ':~:s?$?',
    indent_markers = {
      enable = true,
    },
    highlight_git = true,
  },

  filters = {
    dotfiles = false,
  },

  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
      window_picker = {
        enable = true,
      },
    },
  },

  diagnostics = {
    enable = true,
    show_on_dirs = true,
  },

  view = {
    width = 40,
    side = 'left',
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
  },
}

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
