if vim.g.did_load_nvim_tree_plugin then
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup {
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },

  renderer = {
    root_folder_label = ":~:s?$?",
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
    side = "left",
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
  },
}

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
