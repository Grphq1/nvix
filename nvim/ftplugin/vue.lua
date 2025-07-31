local eslint = require('user.eslint')

vim.lsp.start {
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  init_options = {
    plugins = { {
      name = "@vue/typescript-plugin",
      location = vim.env.VUE_TYPESCRIPT_PLUGIN,
      languages = { "vue" }
    } }
  }
}


vim.lsp.start {
  name = "volar",
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  init_options = {
    vue = {
      hybridMode = true
    },
    typescript = {
      tsdk = vim.env.VUE_TSDK
    }
  }
}

eslint.setup()
