---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Finds the root directory for a project by looking for specific files
---@param files table List of files to search for (e.g., {'package.json', 'tsconfig.json'})
---@return string The root directory path, falls back to current working directory
function M.find_root_dir(files)
  local root_files = vim.fs.find(files, { upward = true })
  return root_files[1] and vim.fs.dirname(root_files[1]) or vim.fn.getcwd()
end

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add com_nvim_lsp capabilities
  local cmp_lsp = require('cmp_nvim_lsp')
  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
  capabilities = vim.tbl_deep_extend('keep', capabilities, cmp_lsp_capabilities)
  -- Add any additional plugin capabilities here.
  -- Make sure to follow the instructions provided in the plugin's docs.
  return capabilities
end

return M
