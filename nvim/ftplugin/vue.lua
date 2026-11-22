local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')
local unocss = require('user.unocss')
local oxlint = require('user.oxlint')
local oxfmt = require('user.oxfmt')

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

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

vim.lsp.start {
  name = 'vtsls',

  cmd = {
    'vtsls',
    '--stdio',
  },

  root_dir = root,

  filetypes = {
    'typescript',
    'javascript',
    'javascriptreact',
    'typescriptreact',
    'vue',
  },

  init_options = {
    hostInfo = 'neovim',
  },

  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
}

vim.lsp.start {
  name = 'vue_ls',

  cmd = {
    'vue-language-server',
    '--stdio',
  },

  root_dir = root,

  filetypes = {
    'vue',
  },

  on_init = function(client)
    local retries = 0

    ---@param _ lsp.ResponseError
    ---@param result any
    ---@param context lsp.HandlerContext
    local function typescript_handler(_, result, context)
      local ts_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]

      if not ts_client then
        -- vtsls may still be starting, so retry briefly
        if retries <= 10 then
          retries = retries + 1
          vim.defer_fn(function()
            typescript_handler(_, result, context)
          end, 100)
        else
          vim.notify('Could not find `vtsls` LSP client required by `vue_ls`.', vim.log.levels.ERROR)
        end
        return
      end

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
        local response_data = {
          { id, r and r.body },
        }

        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end

    client.handlers['tsserver/request'] = typescript_handler
  end,
}

tailwindcss.setup()
unocss.setup()
eslint.setup()
oxlint:setup()
oxfmt:setup()
