return {
  'jackMort/ChatGPT.nvim',
  keys = '<space>a',
  cmd = 'ChatGPT',
  config = function()
    require('chatgpt').setup {
      api_key_cmd = 'pass show api/openai',
    }
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
}
