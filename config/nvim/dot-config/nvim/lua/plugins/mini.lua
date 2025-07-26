return {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects", -- needed for diF
            dependencies = { "nvim-treesitter/nvim-treesitter" },
        },
    },
    -- TODO dif doesn't work if end of function is more than 50 lines away.
    -- figure out what 'cover' and all that does. feels like if function
    -- definition is right above you mini.ai should be able to figure things out
    config = function()
        require("mini.pairs").setup()
        vim.g.minipairs_disable = true
        vim.keymap.set("n", "<leader>A", function()
            vim.g.minipairs_disable = not vim.g.minipairs_disable
        end, { desc = "Toggle MiniPairs" })

        require("mini.splitjoin").setup()

        -- try cina, cila. need to get these under my fingers
        local spec_treesitter = require("mini.ai").gen_spec.treesitter
        require("mini.ai").setup({
            n_lines = 100,
            -- search_method = "cover_or_nearest",
            custom_textobjects = {
                B = function()
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line("$"),
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
            },
        })

        require("mini.icons").setup()

        -- require('mini.tabline').setup()

        -- require('mini.pick').setup({
        --     window = {
        --         config = {
        --             border = 'single',
        --         },
        --         prompt_prefix = ' 🔎 ',
        --     },
        -- })
        -- vim.keymap.set('n', '<leader>f', function()
        --     MiniPick.builtin.files()
        -- end, { desc = 'Pick [F]iles' })
        -- vim.keymap.set('n', '<leader>G', function()
        --     MiniPick.builtin.grep_live()
        -- end, { desc = 'Live [G]rep' })
        -- vim.keymap.set('n', '<leader>h', function()
        --     MiniPick.builtin.help()
        -- end, { desc = 'Pick [H]elp' })
        --
        -- require('mini.files').setup()
        -- vim.keymap.set('n', '-', function()
        --     MiniFiles.open()
        -- end, { desc = 'Open Mini Files' })

        if vim.fn.argc() == 0 and vim.uv.fs_stat("Session.vim") then
            require("mini.sessions").setup({ autowrite = true })
            MiniSessions.read("Session.vim")
        elseif vim.uv.fs_stat("Session.vim") == nil then
            require("mini.sessions").setup({ autowrite = true })
        else
            require("mini.sessions").setup({ autowrite = false })
        end

        vim.keymap.set("n", "<leader>sw", function()
            MiniSessions.write("Session.vim")
        end, { desc = "Write Local Session" })
        vim.keymap.set("n", "<leader>sr", function()
            MiniSessions.read()
        end, { desc = "Read Session" })
        vim.keymap.set("n", "<leader>ss", function()
            MiniSessions.select()
        end, { desc = "Select Session" })
        vim.keymap.set("n", "<leader>sd", function()
            MiniSessions.select("delete", { force = true })
        end, { desc = "Delete Session" })
        -- local session_file = vim.fn.getcwd() .. '/Session.vim'
        -- if vim.fn.filereadable(session_file) == 1 then
        --   local ok, ms = pcall(require, 'mini.sessions')
        --   if ok then
        --     ms.read('Session.vim')
        --   end
        -- end

        require("mini.operators").setup({
            replace = {
                prefix = "g<c-r>",
                -- Whether to reindent new text to match previous indent
                reindent_linewise = true,
            },
            -- Each entry configures one operator.
            -- `prefix` defines keys mapped during `setup()`: in Normal mode
            -- to operate on textobject and line, in Visual - on selection.

            -- Evaluate text and replace with output
            -- evaluate = {
            --     -- prefix = 'g=',
            --     prefix = '',
            -- },
            -- exchange = {
            --     prefix = 'gx',
            --     -- Whether to reindent new text to match previous indent
            --     reindent_linewise = true,
            -- },
            -- -- Multiply (duplicate) text
            -- multiply = {
            --     prefix = 'gm',
            --     -- Function which can modify text before multiplying
            --     func = nil,
            -- },
            -- Replace text with register

            -- Sort text
            -- sort = {
            --     prefix = '',
            --     -- prefix = 'gs',
            --
            --     -- Function which does the sort
            --     func = nil,
            -- },
        }) -- gr, g=, gx, gm, gs

        -- require('mini.completion').setup()

        -- local hipatterns = require('mini.hipatterns')
        -- hipatterns.setup({
        --     highlighters = {
        --         fixme = { pattern = 'FIXME', group = 'MiniHipatternsHack' },
        --         hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
        --         todo = { pattern = 'TODO', group = 'MiniHipatternsHack' },
        --         note = { pattern = 'NOTE', group = 'MiniHipatternsHack' },
        --         hex_color = hipatterns.gen_highlighter.hex_color(),
        --     },
        -- })

        -- require('mini.surround').setup()
    end,
}
