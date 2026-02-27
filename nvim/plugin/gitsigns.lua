if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

vim.schedule(function()
  require('gitsigns').setup {
    current_line_blame = false,
    current_line_blame_opts = {
      ignore_whitespace = true,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']g', function()
        if vim.wo.diff then
          return ']g'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[g]it next hunk' })

      map('n', '[g', function()
        if vim.wo.diff then
          return '[g'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true, desc = '[g]it previous hunk' })

      -- Actions
      map({ 'n', 'v' }, '<leader>ghs', function()
        vim.cmd.Gitsigns('stage_hunk')
      end, { desc = 'git [h]unk [s]tage' })
      map({ 'n', 'v' }, '<leader>ghr', function()
        vim.cmd.Gitsigns('reset_hunk')
      end, { desc = 'git [h]unk [r]eset' })
      map('n', '<leader>ghS', gs.stage_buffer, { desc = 'git stage buffer' })
      map('n', '<leader>ghu', gs.undo_stage_hunk, { desc = 'git [h]unk [u]ndo stage' })
      map('n', '<leader>ghR', gs.reset_buffer, { desc = 'git [h] buffer [R]eset' })
      map('n', '<leader>ghp', gs.preview_hunk, { desc = 'git [h]unk [p]review' })
      map('n', '<leader>ghb', function()
        gs.blame_line { full = true }
      end, { desc = 'git [h] [b]lame line (full)' })
      map('n', '<leader>glb', gs.toggle_current_line_blame, { desc = '[g]it toggle current [l]ine [b]lame' })
      map('n', '<leader>ghd', gs.diffthis, { desc = 'git [h] [d]iff this' })
      map('n', '<leader>ghD', function()
        gs.diffthis('~')
      end, { desc = 'git [h] [D]iff ~' })
      map('n', '<leader>gtd', gs.toggle_deleted, { desc = 'git [t]oggle [d]eleted' })
      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'git stage buffer' })
    end,
  }
end)
