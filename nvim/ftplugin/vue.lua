local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')
local unocss = require('user.unocss')

local tsdk = vim.env.VUE_TSDK
if not tsdk then
  local root = vim.fs.root(0, { 'package.json', 'tsconfig.json', '.git' })
  if root then
    local local_ts = root .. '/node_modules/typescript/lib'
    if vim.fn.isdirectory(local_ts) == 1 then
      tsdk = local_ts
    end
  end
end

local vue_plugin_location = vim.env.VUE_TYPESCRIPT_PLUGIN
if not vue_plugin_location then
  local root = vim.fs.root(0, { 'package.json', 'tsconfig.json', '.git' })
  if root then
    local local_vue = root .. '/node_modules/@vue/language-server'
    if vim.fn.isdirectory(local_vue) == 1 then
      vue_plugin_location = local_vue
    end
  end
end

if not tsdk then
  vim.notify(
    'VUE_TSDK environment variable not set and TypeScript not found in node_modules.\n'
      .. 'Please set VUE_TSDK or install TypeScript locally.',
    vim.log.levels.ERROR
  )
  return
end

if not vue_plugin_location then
  vim.notify(
    'VUE_TYPESCRIPT_PLUGIN environment variable not set and @vue/language-server not found.\n'
      .. 'Please set VUE_TYPESCRIPT_PLUGIN or install @vue/language-server locally.',
    vim.log.levels.ERROR
  )
  return
end

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_plugin_location,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.start {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  on_attach = function(client, bufnr)
    -- Disable semantic tokens for Vue files in ts_ls (handled by vue_ls)
    if vim.bo[bufnr].filetype == 'vue' then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}

vim.lsp.start {
  name = 'vue_ls',
  cmd = { 'vue-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'package.json', 'vue.config.js', 'nuxt.config.js', '.git' }),
  init_options = {
    vue = {
      hybridMode = false, -- Set to false for Vue 3 (true for Vue 2)
    },
    typescript = {
      tsdk = tsdk,
    },
  },
  on_new_config = function(new_config, new_root_dir)
    -- automatically detect Vue version and set hybridMode accordingly
    local package_json = new_root_dir .. '/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      local content = vim.fn.readfile(package_json)
      local json_str = table.concat(content, '\n')
      if json_str:match('"vue"%s*:%s*"[~^]?2%.') then
        new_config.init_options.vue.hybridMode = true
      end
    end
  end,
  on_init = function(client)
    -- handle tsserver/request forwarding from vue_ls to ts_ls
    client.handlers['tsserver/request'] = function(_, result, context)
      local ts_clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'ts_ls' }

      if #ts_clients == 0 then
        vim.notify(
          'Could not find `ts_ls` LSP client. `vue_ls` requires it for full functionality.',
          vim.log.levels.WARN
        )
        return
      end

      local ts_client = ts_clients[1]
      local param = unpack(result)
      local id, command, payload = unpack(param)

      ts_client:exec_cmd({
        title = 'vue_request_forward',
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response = r and r.body
        local response_data = { { id, response } }

        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end
  end,
}

tailwindcss.setup()
unocss.setup()
eslint.setup()
