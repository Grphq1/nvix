if vim.g.did_load_avante_plugin then
  return
end
vim.g.did_load_avante_plugin = true

require('avante_lib').load()
require('avante').setup {
  debug = false,
  provider = 'claude',
  auto_suggestions_provider = 'openai',

  openai = {
    endpoint = 'https://api.avalapis.ir/v1',
    temperature = 0.7,
    model = 'o4-mini',
    max_tokens = 4096,
  },

  claude = {
    endpoint = 'https://api.avalapis.ir',
    model = 'anthropic.claude-3-7-sonnet-20250219-v1:0',
    temperature = 0.7,
    max_tokens = 4096,
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
