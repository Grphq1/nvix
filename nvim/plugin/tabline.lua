if vim.g.did_load_tabline_framework_plugin then
  return
end
vim.g.did_load_tabline_framework_plugin = true

vim.o.showtabline = 2

local function hl_color(group, attr)
  attr = attr or "fg"
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not hl or not hl[attr] then return nil end
  return string.format("#%06x", hl[attr])
end

local function get_colors()
  return {
    fg     = hl_color("Normal", "fg")  or "#abb2bf",
    dim    = hl_color("Comment", "fg") or "#5c6370",
    accent = hl_color("Function", "fg")
          or hl_color("DiagnosticInfo", "fg")
          or "#61afef",
    mod    = hl_color("DiagnosticError", "fg") or "#e06c75",
  }
end

local function truncate(s, max)
  if not s or #s <= max then return s end
  return s:sub(1, max - 1) .. "…"
end

vim.api.nvim_create_autocmd(
  { "BufEnter", "BufAdd", "BufDelete", "BufWipeout" },
  {
    callback = function()
      vim.schedule(function()
        local listed = vim.fn.getbufinfo({ buflisted = 1 })
        vim.o.showtabline = #listed > 1 and 2 or 0
      end)
    end,
  }
)

local render = function(f)
  local c   = get_colors()
  local cur = vim.api.nvim_get_current_buf()

  local bufs = vim.tbl_filter(function(b)
    return vim.fn.buflisted(b) == 1
  end, vim.api.nvim_list_bufs())

  f.add({ " ", fg = c.dim, bg = "NONE" })

  f.make_bufs(function(info)
    local is_current = info.current or info.buf == cur
    local name = info.filename
        and vim.fn.fnamemodify(info.filename, ":t")
        or "[No Name]"
    name = truncate(name, 20)

    if not info.first then
      f.add({ " ", fg = c.dim, bg = "NONE" })
    end

    if is_current then
      f.add({ " " .. name .. " ", fg = c.accent, bg = "NONE", gui = "bold" })
      if info.modified then
        f.add({ "● ", fg = c.mod, bg = "NONE", gui = "bold" })
      end
    else
      f.add({ " " .. name .. " ", fg = c.dim, bg = "NONE" })
      if info.modified then
        f.add({ "● ", fg = c.mod, bg = "NONE" })
      end
    end
  end, bufs)

  f.add_spacer()
  f.add({ " ", fg = c.dim, bg = "NONE" })
end

local c0 = get_colors()
require("tabline_framework").setup({
  render  = render,
  hl      = { fg = c0.dim,    bg = "NONE" },
  hl_sel  = { fg = c0.accent, bg = "NONE", gui = "bold" },
  hl_fill = { fg = c0.dim,    bg = "NONE" },
})
