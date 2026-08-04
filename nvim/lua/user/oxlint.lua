local M = {}

local lsp = require('user.lsp')

M.filetypes = {
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'vue',
  'svelte',
  'astro',
}

local root_markers = {
  '.oxlintrc.json',
  '.oxlintrc.jsonc',
  'oxlint.config.ts',
}

function M.oxlint_conf_mentions_typescript(root_dir)
  local path = vim.fs.joinpath(root_dir, '.oxlintrc.json')

  if vim.fn.filereadable(path) == 0 then
    return false
  end

  for line in io.lines(path) do
    if line:find('typescript') then
      return true
    end
  end

  return false
end

M.cmd = function(dispatchers, config)
  local cmd = 'oxlint'

  if config.root_dir then
    local local_cmd = vim.fs.joinpath(
      config.root_dir,
      'node_modules/.bin',
      cmd
    )

    if vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
  end

  return vim.lsp.rpc.start({
    cmd,
    '--lsp',
  }, dispatchers)
end

M.on_attach = function(client, bufnr)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'LspOxlintFixAll',
    function()
      client:exec_cmd {
        title = 'Apply Oxlint automatic fixes',
        command = 'oxc.fixAll',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
          },
        },
      }
    end,
    {
      desc = 'Apply Oxlint automatic fixes',
    }
  )
end

M.before_init = function(init_params, config)
  local settings = config.settings or {}

  local has_tsgolint = vim.fn.executable('tsgolint') == 1

  if not has_tsgolint and config.root_dir then
    local local_cmd = vim.fs.joinpath(
      config.root_dir,
      'node_modules/.bin',
      'tsgolint'
    )

    has_tsgolint = vim.fn.executable(local_cmd) == 1
  end

  if settings.typeAware == nil
    and has_tsgolint
    and config.root_dir
  then
    local ok, mentions_typescript =
      pcall(M.oxlint_conf_mentions_typescript, config.root_dir)

    if ok and mentions_typescript then
      settings = vim.tbl_extend('force', settings, {
        typeAware = true,
      })
    end
  end

  local init_options = config.init_options or {}

  init_options.settings = vim.tbl_extend(
    'force',
    init_options.settings or {},
    settings
  )

  init_params.initializationOptions = init_options
end

M.setup = function()
  local root_dir = lsp.find_root_dir(root_markers, nil, true)

  if not root_dir then
    return
  end

  vim.lsp.start {
    name = 'oxlint',
    cmd = M.cmd,
    filetypes = M.filetypes,
    root_dir = root_dir,
    workspace_required = true,

    on_attach = M.on_attach,
    before_init = M.before_init,

    settings = {
      run = 'onSave',
      -- configPath = nil,
      -- tsConfigPath = nil,
      -- unusedDisableDirectives = 'allow',
      -- typeAware = false,
      -- disableNestedConfig = false,
      -- fixKind = 'safe_fix',
    },
  }
end

return M
