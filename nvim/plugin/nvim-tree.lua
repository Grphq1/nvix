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

-- auto close
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#rwblokzijl
local function tab_win_closed(winnr)
  local api = require"nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})
