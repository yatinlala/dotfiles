-- Add indentation guidelines
return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufWinEnter',
  config = function()
    require('indent_blankline').setup({
      char = '┆',
    })
  end,
}
