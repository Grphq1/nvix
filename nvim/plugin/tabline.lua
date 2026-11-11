if vim.g.did_load_tabline_framework_plugin then
  return
end
vim.g.did_load_tabline_framework_plugin = true

-- always visible
vim.o.showtabline = 2

local function hl_color(group, attr)
  attr = attr or "fg"
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if not ok or not hl or not hl[attr] then return nil end
  return string.format("#%06x", hl[attr])
end

local function get_colors()
  return {
    fg       = hl_color("Normal", "fg")   or "#abb2bf",
    dim      = hl_color("Comment", "fg")  or "#5c6370",
    accent   = hl_color("Function", "fg")
            or hl_color("DiagnosticInfo", "fg")
            or "#61afef",
    mod      = hl_color("DiagnosticError", "fg") or "#e06c75",
    tag      = hl_color("DiagnosticWarn", "fg")  or "#e5c07b",
    tag_dim  = hl_color("Comment", "fg")         or "#5c6370",
    sep      = hl_color("Comment", "fg")         or "#5c6370",
  }
end

local function truncate(s, max)
  if not s or #s <= max then return s end
  return s:sub(1, max - 1) .. "…"
end

local function get_grapple_tag(bufnr)
  local ok, grapple = pcall(require, "grapple")
  if not ok then return nil end
  local success, tag = pcall(grapple.find, { buffer = bufnr })
  if not success or not tag then return nil end
  return tag
end

local function get_listed_buffer_paths()
  local paths = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        paths[vim.fn.fnamemodify(name, ":p")] = true
      end
    end
  end
  return paths
end

local render = function(f)
  local c   = get_colors()
  local cur = vim.api.nvim_get_current_buf()

  local bufs = vim.tbl_filter(function(b)
    return vim.fn.buflisted(b) == 1
  end, vim.api.nvim_list_bufs())

  f.add({ " ", fg = c.dim, bg = "NONE" })

  -- 1. Buffers
  f.make_bufs(function(info)
    local is_current = info.current or info.buf == cur
    local name = info.filename
        and vim.fn.fnamemodify(info.filename, ":t")
        or "[No Name]"
    name = truncate(name, 20)

    if not info.first then
      f.add({ " ", fg = c.dim, bg = "NONE" })
    end

    local tag = get_grapple_tag(info.buf)
    if tag then
      local label = tag.index and tostring(tag.index) or ""
      f.add({ "⚑" .. label .. " ", fg = c.tag, bg = "NONE", gui = "bold" })
    end

    if is_current then
      f.add({ " " .. name .. " ", fg = c.accent, bg = "NONE", gui = "bold" })
      if info.modified then
        f.add({ "● ", fg = c.mod, bg = "NONE", gui = "bold" })
      end
    else
      f.add({ " " .. name .. " ", fg = c.fg, bg = "NONE" })
      if info.modified then
        f.add({ "● ", fg = c.mod, bg = "NONE" })
      end
    end
  end, bufs)

  -- 2. Orphan tags
  local ok, grapple = pcall(require, "grapple")
  if ok then
    local success, all_tags = pcall(grapple.tags)
    if success and all_tags and #all_tags > 0 then
      local buffer_paths = get_listed_buffer_paths()
      local orphans = {}
      for _, tag in ipairs(all_tags) do
        local tag_path = tag.path and vim.fn.fnamemodify(tag.path, ":p")
        if tag_path and not buffer_paths[tag_path] then
          table.insert(orphans, tag)
        end
      end

      if #orphans > 0 then
        -- dotted vertical separator between sections
        f.add({ " ⋮ ", fg = c.sep, bg = "NONE", gui = "bold" })

        for _, tag in ipairs(orphans) do
          local label = tag.index and tostring(tag.index) or ""
          local name = tag.path and vim.fn.fnamemodify(tag.path, ":t") or "?"
          name = truncate(name, 20)

          f.add({ " ", fg = c.dim, bg = "NONE" })
          f.add({ "⚑" .. label .. " ", fg = c.tag_dim, bg = "NONE", gui = "italic" })
          f.add({ " " .. name .. " ", fg = c.tag_dim, bg = "NONE", gui = "italic" })
        end
      end
    end
  end

  f.add_spacer()
  f.add({ " ", fg = c.dim, bg = "NONE" })
end

local c0 = get_colors()
require("tabline_framework").setup({
  render  = render,
  hl      = { fg = c0.fg,     bg = "NONE" },
  hl_sel  = { fg = c0.accent, bg = "NONE", gui = "bold" },
  hl_fill = { fg = c0.dim,    bg = "NONE" },
})
