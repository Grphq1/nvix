local eslint = require('user.eslint')
local tailwindcss = require('user.tailwindcss')

vim.lsp.start {
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vim.env.VUE_TYPESCRIPT_PLUGIN,
        languages = { 'vue' },
      },
    },
  },
}

vim.lsp.start {
  name = 'volar',
  cmd = { 'vue-language-server', '--stdio' },
  root_dir = vim.fs.root(0, { 'package.json', 'vue.config.js', 'nuxt.config.js', '.git' }),
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = vim.env.VUE_TSDK,
    },
  },
}

tailwindcss.setup()
eslint.setup()
