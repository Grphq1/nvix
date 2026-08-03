local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')
local unocss = require('user.unocss')

local root_markers = {
  'package.json',
  'tsconfig.json',
  'jsconfig.json',
  'vue.config.js',
  'nuxt.config.js',
  '.git',
}

local root = vim.fs.root(0, root_markers)

if not root then
  vim.notify('Could not find project root.', vim.log.levels.ERROR)
  return
end

local tsdk = vim.env.VUE_TSDK

if not tsdk then
  local local_ts = root .. '/node_modules/typescript/lib'

  if vim.fn.isdirectory(local_ts) == 1 then
    tsdk = local_ts
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

local vue_language_server_path = vim.env.VUE_TYPESCRIPT_PLUGIN

if not vue_language_server_path then
  local local_vue = root .. '/node_modules/@vue/language-server'

  if vim.fn.isdirectory(local_vue) == 1 then
    vue_language_server_path = local_vue
  end
end

if not vue_language_server_path then
  vim.notify(
    'VUE_TYPESCRIPT_PLUGIN environment variable not set and @vue/language-server not found.\n'
      .. 'Please set VUE_TYPESCRIPT_PLUGIN or install @vue/language-server locally.',
    vim.log.levels.ERROR
  )
  return
end

local tsserver_filetypes = {
  'typescript',
  'javascript',
  'javascriptreact',
  'typescriptreact',
  'vue',
}

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.start {
  name = 'ts_ls',

  cmd = {
    'typescript-language-server',
    '--stdio',
  },

  root_dir = vim.fs.root(0, root_markers),

  filetypes = tsserver_filetypes,

  init_options = {
    plugins = {
      vue_plugin,
    },
  },
}

vim.lsp.start {
  name = 'vue_ls',

  cmd = {
    'vue-language-server',
    '--stdio',
  },

  root_dir = vim.fs.root(0, root_markers),

  filetypes = {
    'vue',
  },

  init_options = {
    vue = {
      hybridMode = false,
    },

    typescript = {
      tsdk = tsdk,
    },
  },

  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local ts_clients = vim.lsp.get_clients {
        bufnr = context.bufnr,
        name = 'ts_ls',
      }

      if #ts_clients == 0 then
        vim.notify(
          'Could not find `ts_ls` LSP client. `vue_ls` requires it for full functionality.',
          vim.log.levels.ERROR
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
      }, {
        bufnr = context.bufnr,
      }, function(_, r)
        local response = r and r.body

        local response_data = {
          { id, response },
        }

        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end
  end,
}

tailwindcss.setup()
unocss.setup()
eslint.setup()
