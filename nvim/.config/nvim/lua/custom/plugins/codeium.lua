return {
    'Exafunction/codeium.vim',
    keys = { { '<c-;>', mode = 'i' } },
    config = function()
        vim.g.codeium_disable_bindings = 1

        vim.keymap.set('i', '<Tab>', function()
            return vim.fn['codeium#Accept']()
        end, { desc = 'Accept Codeium Suggestion', expr = true, silent = true })
        vim.keymap.set('i', '<C-;>', function()
            return vim.fn['codeium#CycleCompletions'](1)
        end, { desc = 'Codeium Cycle Forward', expr = true, silent = true })
        vim.keymap.set('i', '<C-,>', function()
            return vim.fn['codeium#CycleCompletions'](-1)
        end, { desc = 'Codeium Cycle Backward', expr = true, silent = true })
        vim.keymap.set('i', '<c-x>', function()
            return vim.fn['codeium#Clear']()
        end, { desc = 'Codeium Clear', expr = true, silent = true })
    end,
}
