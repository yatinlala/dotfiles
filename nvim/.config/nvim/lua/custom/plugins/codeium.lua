-- TODO figure out how to display in statusline. check github
return {
    {
        'Exafunction/codeium.vim',
        -- event = 'BufWinEnter',
        cmd = 'CodeiumToggle',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            vim.g.codeium_enabled = true
            vim.keymap.set('i', '<Tab>', function()
                return vim.fn['codeium#Accept']()
            end, { expr = true, silent = true })
            vim.keymap.set('i', '<M-]>', function()
                return vim.fn['codeium#CycleCompletions'](1)
            end, { expr = true, silent = true })
            vim.keymap.set('i', '<M-[>', function()
                return vim.fn['codeium#CycleCompletions'](-1)
            end, { expr = true, silent = true })
            vim.keymap.set('i', '<C-]>', function()
                return vim.fn['codeium#Clear']()
            end, { expr = true, silent = true })
        end,
    },
    -- {
    --     'Exafunction/codeium.nvim',
    --     cmd = 'CodeiumToggle',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'hrsh7th/nvim-cmp',
    --     },
    --     config = function()
    --         require('codeium').setup({})
    --     end,
    -- },
}
