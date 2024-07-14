return {
    'NVChad/nvim-colorizer.lua',
    cmd = 'ColorizerToggle',
    keys = { '<leader>C' },
    config = function()
        require('colorizer').setup()
    end,
}
