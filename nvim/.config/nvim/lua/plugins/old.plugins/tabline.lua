return {
    'mkitt/tabline.vim',
    dependencies = 'ellisonleao/gruvbox.nvim',
    enabled = false,
    lazy = false,
    config = function()
        vim.cmd([[
            hi TabLine      guifg=#bdae93  guibg=#282828     gui=NONE
            hi TabLineFill  guifg=#bdae93  guibg=#282828     gui=NONE
            hi TabLineSel   guifg=#ebdbb2  guibg=#282828     gui=NONE
        ]])
    end,
}
