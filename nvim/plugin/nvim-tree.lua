if vim.g.did_load_nvim_tree_plugin then
  return
end

vim.g.did_load_nvim_tree_plugin = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

local HEIGHT_RATIO = 0.7
local OFFSET = 3

local function my_open_win_config()
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local window_h = screen_h * HEIGHT_RATIO
  local window_h_int = math.floor(window_h)

  -- adjust for the offset
  local col_right_aligned = screen_w - OFFSET
  local row_offset = OFFSET - 3

  return {
    border = 'rounded',
    relative = 'editor',
    row = row_offset,
    col = col_right_aligned,
    width = 30,
    height = window_h_int,
  }
end

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
    preserve_window_proportions = true,
    number = true,
    relativenumber = true,
    signcolumn = 'yes',
    float = {
      enable = true,
      open_win_config = my_open_win_config,
    },
  },

  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
  },
}

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
