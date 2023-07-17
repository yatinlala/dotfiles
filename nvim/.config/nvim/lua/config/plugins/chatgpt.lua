return {
  'jackMort/ChatGPT.nvim',
  event = 'VeryLazy', -- kills splash
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
