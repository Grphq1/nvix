if vim.g.did_load_avante_plugin then
  return
end
vim.g.did_load_avante_plugin = true

require('avante_lib').load()
require('avante').setup {
  debug = false,
  provider = 'mistral_codestral',
  auto_suggestions_provider = 'mistral_codestral',

  providers = {
    openai = {
      endpoint = 'https://api.avalapis.ir/v1',
      model = 'o4-mini',
    },

    mistral_codestral = {
      __inherited_from = 'openai',
      api_key_name = 'MISTRAL_API_KEY',
      endpoint = 'https://api.mistral.ai/v1',
      model = 'mistral-large-latest',
      extra_request_body = {
        max_tokens = 2000,
      },
    },
  },

  highlights = {
    diff = {
      current = 'DiffText',
      incoming = 'DiffAdd',
    },
  },
  windows = {
    position = 'right',
    width = 30,
  },
}
