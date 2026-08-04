---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---@param files string[]
---@param path? string
---@param nil_ok? boolean
---@return string?
function M.find_root_dir(files, path, nil_ok)
  path = path or vim.fn.getcwd()

  local root_files = vim.fs.find(files, {
    path = path,
    upward = true,
  })

  local dir = root_files[1] and vim.fs.dirname(root_files[1])
  if dir then
    return dir
  end
  if nil_ok then
    return nil
  end
  return vim.fn.getcwd()
end

---@diagnostic disable-next-line: undefined-doc-name
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local cmp_lsp = require('cmp_nvim_lsp')
  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()

  capabilities = vim.tbl_deep_extend('keep', capabilities, cmp_lsp_capabilities)

  return capabilities
end

return M
