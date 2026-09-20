local sync = require('user.file_manager_sync')

vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

-- <leader> key. Defaults to `\`. Some people prefer space.
-- The default leader is '\'. Some people prefer <space>. Uncomment this if you do, too.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

opt.spell = true
opt.spelllang = 'en'

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.clipboard = 'unnamedplus'

opt.foldlevel = 99
opt.foldcolumn = '1'
opt.foldlevelstart = 99

opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0


opt.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
-- -- remove vertical center guide
-- opt.colorcolumn = ''

-- enable bidi
opt.termbidi = true

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

sync.setup({
  name = 'lf',
  augroup = 'LfSync',

  sync = function(id, file)
    local dir = vim.fn.shellescape(vim.fs.dirname(file))
    local path = vim.fn.shellescape(file)

    vim.fn.jobstart({
      'lf',
      '-remote',
      ('send %s cd %s'):format(id, dir),
    }, { detach = true })

    vim.fn.jobstart({
      'lf',
      '-remote',
      ('send %s select %s'):format(id, path),
    }, { detach = true })
  end,
})

sync.setup({
  name = 'yazi',
  augroup = 'YaziSync',

  sync = function(id, file)
    vim.fn.jobstart({
      'ya',
      'emit-to',
      id,
      'reveal',
      file,
    }, { detach = true })
  end,
})

