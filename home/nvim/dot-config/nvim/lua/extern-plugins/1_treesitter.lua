vim.pack.add({
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
        data = {
            run = function(_)
                vim.cmd("TSUpdate")
            end,
        },
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        version = "main",
    },
})

require("nvim-treesitter").install({ "c", "html", "javascript", "bash" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "<filetype>" },
    callback = function()
        vim.treesitter.start()
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
    },
})

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

-- require("nvim-treesitter.configs").setup({
--     ensure_installed = {
--         "bash",
--         "c",
--         "diff",
--         "html",
--         "lua",
--         "luadoc",
--         "markdown",
--         "markdown_inline",
--         "query",
--         "vim",
--         "vimdoc",
--     },
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = {
--         enable = true,
--         -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--         --  If you are experiencing weird indenting issues, add the language to
--         --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--         additional_vim_regex_highlighting = { "ruby" },
--     },
--     matchup = { enable = true },
--     indent = { enable = true, disable = { "ruby" } },
-- })

-- There are additional nvim-treesitter modules that you can use to interact
-- with nvim-treesitter. You should go explore a few and see what interests you:
--
--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

-- -- TODO add text objects dif
-- return { -- Highlight, edit, and navigate code
--     'nvim-treesitter/nvim-treesitter',
--     dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
--     event = 'VeryLazy',
--     build = ':TSUpdate',
--     opts = {
--         ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
--         -- Autoinstall languages that are not installed
--         auto_install = true,
--         highlight = {
--             enable = true,
--             -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
--             --  If you are experiencing weird indenting issues, add the language to
--             --  the list of additional_vim_regex_highlighting and disabled languages for indent.
--             additional_vim_regex_highlighting = { 'ruby' },
--         },
--         indent = { enable = true, disable = { 'ruby' } },
--
--         textobjects = {
--             select = {
--                 enable = true,
--                 lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--                 keymaps = {
--                     -- You can use the capture groups defined in textobjects.scm
--                     ['aa'] = '@parameter.outer',
--                     ['ia'] = '@parameter.inner',
--                     ['af'] = '@function.outer',
--                     ['if'] = '@function.inner',
--                     ['ac'] = '@class.outer',
--                     ['ic'] = '@class.inner',
--                     ['ii'] = '@conditional.inner',
--                     ['ai'] = '@conditional.outer',
--                     ['il'] = '@loop.inner',
--                     ['al'] = '@loop.outer',
--                     ['at'] = '@comment.outer',
--                 },
--             },
--             move = {
--                 enable = true,
--                 set_jumps = true, -- whether to set jumps in the jumplist
--                 goto_next_start = {
--                     [']f'] = '@function.outer',
--                     [']]'] = '@class.outer',
--                 },
--                 goto_next_end = {
--                     [']F'] = '@function.outer',
--                     [']['] = '@class.outer',
--                 },
--                 goto_previous_start = {
--                     ['[f'] = '@function.outer',
--                     ['[['] = '@class.outer',
--                 },
--                 goto_previous_end = {
--                     ['[F'] = '@function.outer',
--                     ['[]'] = '@class.outer',
--                 },
--             },
--             swap = {
--                 enable = true,
--                 swap_next = {
--                     ['<leader>ta'] = '@parameter.inner',
--                 },
--                 swap_previous = {
--                     ['<leader>tA'] = '@parameter.inner',
--                 },
--             },
--         },
--     },
--     config = function(_, opts)
--         -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--
--         ---@diagnostic disable-next-line: missing-fields
--         require('nvim-treesitter.configs').setup(opts)
--
--         -- There are additional nvim-treesitter modules that you can use to interact
--         -- with nvim-treesitter. You should go explore a few and see what interests you:
--         --
--         --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--         --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--         --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--     end,
-- }
-- --     {
-- --         'nvim-treesitter/nvim-treesitter-textobjects',
-- --         dependencies = { 'nvim-treesitter/nvim-treesitter' },
-- --         event = 'VeryLazy',
-- --     },
-- --     {
-- --         'JoosepAlviste/nvim-ts-context-commentstring',
-- --         keys = { 'gc', 'gb', 'gcc', 'gbc', 'v', 'V' },
-- --         config = function()
-- --             vim.g.skip_ts_context_commentstring_module = true
-- --         end,
-- --     },
-- --     {
-- --         'Wansmer/treesj',
-- --         event = 'VeryLazy',
-- --         dependencies = { 'nvim-treesitter/nvim-treesitter' },
-- --         config = function()
-- --             require('treesj').setup({ --[[ your config ]]
-- --                 use_default_keymaps = false,
-- --             })
-- --         end,
-- --     },
-- --     {
-- --         'nvim-treesitter/nvim-treesitter-context',
-- --         enabled = true,
-- --         event = 'BufWinEnter',
-- --         dependencies = 'nvim-treesitter/nvim-treesitter',
-- --         config = function()
-- --             require('treesitter-context').setup({
-- --                 max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
-- --                 min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
-- --                 line_numbers = true,
-- --                 multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
-- --                 trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
-- --                 mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
-- --                 -- Separator between context and content. Should be a single character string, like '-'.
-- --                 -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
-- --                 separator = nil,
-- --                 zindex = 20, -- The Z-index of the context window
-- --                 on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
-- --             })
-- --         end,
-- --     },
-- -- }
