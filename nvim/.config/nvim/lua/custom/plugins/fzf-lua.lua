return {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
        {
            '<leader>f',
            function()
                require('fzf-lua').files()
            end,
            desc = 'Find [F]iles',
        },
        {
            '<leader>h',
            function()
                require('fzf-lua').help_tags()
            end,
            desc = 'Find [F]iles',
        },
        {
            '<leader>G',
            function()
                require('fzf-lua').live_grep_native()
            end,
            desc = 'Live [G]rep',
        },
    },
    dependencies = {
        { 'echasnovski/mini.icons' },
        -- { "junegunn/fzf", build = "./install --bin" } -- uncomment if env doesn't have fzf installed
    },
    config = function()
        -- calling `setup` is optional for customization
        require('fzf-lua').setup({})
    end,
}
