return {
    'ibhagwan/fzf-lua',
    enabled = false,
    cmd = 'FzfLua',
    keys = {
        -- {
        --     '<leader>f',
        --     function()
        --         require('fzf-lua').files()
        --     end,
        --     desc = 'Find [F]iles',
        -- },
        -- {
        --     '<leader>h',
        --     function()
        --         require('fzf-lua').help_tags()
        --     end,
        --     desc = 'Find [F]iles',
        -- },
        -- {
        --     '<leader>G',
        --     function()
        --         require('fzf-lua').live_grep_native()
        --     end,
        --     desc = 'Live [G]rep',
        -- },
    },
    dependencies = {
        { 'echasnovski/mini.icons' },
        -- { "junegunn/fzf", build = "./install --bin" } -- uncomment if env doesn't have fzf installed
    },
    config = function()
        -- calling `setup` is optional for customization
        require('fzf-lua').setup({
            winopts_fn = function()
                -- local split = "botright new" -- use for split under **all** windows
                local split = 'belowright new' -- use for split under current window
                local height = math.floor(vim.o.lines * 0.4)
                return { split = split .. ' | resize ' .. tostring(height) }
            end,
            winopts = {
                -- "belowright new"  : split below
                -- "aboveleft new"   : split above
                -- "belowright vnew" : split right
                -- "aboveleft vnew   : split left
                border = 'none',

                preview = {
                    border = 'noborder',
                },
            },
        })
    end,
}
