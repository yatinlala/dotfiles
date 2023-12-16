local M = {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'andymass/vim-matchup' },
    -- event = "VeryLazy",
    lazy = false,
}

function M.config()
    require('nvim-treesitter.configs').setup({
        ensure_installed = { },
        -- List of parsers to ignore installing (for "all")
        ignore_install = { '' },

        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- disable = { "c", "rust" },

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            -- additional_vim_regex_highlighting = { 'org' },
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gnn',
                node_incremental = 'gRn',
                scope_incremental = 'gRc',
                node_decremental = 'gRm',
            },
        },

    })
    require('nvim-treesitter.install').prefer_git = true
end

return M
