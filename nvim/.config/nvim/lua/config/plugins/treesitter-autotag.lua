return {
  'windwp/nvim-ts-autotag',
  event = 'BufWinEnter',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-treesitter.configs').setup({
      autotag = {
        enable = true,
      },
    })
  end,
}
