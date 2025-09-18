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
    model = 'gpt-4o-mini-2024-07-18',
    max_tokens = 4096,
  },

  claude = {
    endpoint = 'https://api.avalai.ir',
    model = 'anthropic.claude-sonnet-4-20250514-v1:0',
    temperature = 0.7,
    max_tokens = 4096,
  },

  highlights = {
    diff = {
      current = 'DiffText',
      incoming = 'DiffAdd',
    },
  },
}
