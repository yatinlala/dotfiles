return {
    'mkitt/tabline.vim',
    dependencies = 'ellisonleao/gruvbox.nvim',
    lazy = false,
    config = function()
        vim.cmd([[
            hi TabLine      guifg=#ebdbb2  guibg=#3c3836     gui=NONE
            hi TabLineFill  guifg=#ebdbb2  guibg=#3c3836     gui=NONE
            hi TabLineSel   guifg=#ebdbb2  guibg=#928374     gui=NONE
        ]])
    end,
}
