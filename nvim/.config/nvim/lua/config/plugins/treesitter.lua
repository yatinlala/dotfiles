local M = {
    "nvim-treesitter/nvim-treesitter",
    -- event = "VeryLazy",
    event = "BufWinEnter",
}

function M.config()
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "org" },
        -- List of parsers to ignore installing (for "all")
        ignore_install = { "" },

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
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        matchup = {
            enable = true, -- mandatory, false will disable the whole extension
            -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
            disable_virtual_text = false,
        },
		rainbow = {
			enable = true,
			-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
		},
    })
    require("nvim-treesitter.install").prefer_git = true
end

return M
