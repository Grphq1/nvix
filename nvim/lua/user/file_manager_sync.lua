local M = {}

function M.read_id(name)
  local session = vim.env.ZELLIJ_SESSION_NAME
  if not session or session == '' then
    return nil
  end

  local f = io.open('/tmp/' .. name .. '-' .. session .. '.id', 'r')
  if not f then
    return nil
  end

  local id = f:read('*l')
  f:close()

  return id and id:gsub('%s+$', '') or nil
end

function M.setup(opts)
  local group = vim.api.nvim_create_augroup(opts.augroup, { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    group = group,
    callback = function()
      if vim.bo.buftype ~= '' then
        return
      end

      local file = vim.api.nvim_buf_get_name(0)
      if file == '' or vim.fn.filereadable(file) == 0 then
        return
      end

      local id = M.read_id(opts.name)
      if id then
        opts.sync(id, file)
      end
    end,
  })
end

return M
