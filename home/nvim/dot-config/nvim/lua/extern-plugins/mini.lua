-- vim : foldmethod=marker

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- dependencies
-- "nvim-treesitter/nvim-treesitter-textobjects", -- needed for diF
-- "nvim-treesitter/nvim-treesitter"

-- require('mini.misc').setup_auto_root()

require("mini.misc").setup_restore_cursor()

require("mini.icons").setup()

require("mini.splitjoin").setup()

require("mini.completion").setup({
    delay = { completion = 150, info = 100, signature = 50 },
})

--: surround {{{

-- :h MiniSurround *MiniSurround-vim-surround-config*
require("mini.surround").setup({
    mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",

        -- Add this only if you don't want to use extended mappings
        -- suffix_last = '',
        -- suffix_next = '',
    },
    search_method = "cover_or_next",
})

-- Remap adding surrounding to Visual mode selection
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

-- Make special mapping for "add surrounding for line"
vim.keymap.set("n", "yss", "ys_", { remap = true })

--: }}}

--: indentscope {{{

vim.keymap.set("n", "<leader>i", function()
    require("mini.indentscope").setup({
        draw = {
            animation = require("mini.indentscope").gen_animation.none(),
        },
    })
end, { desc = "Enable Indentscope" })

--: }}}

--: pairs {{{

require("mini.pairs").setup({
    mappings = {

        ["("] = false,
        ["["] = false,
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

        [")"] = false,
        ["]"] = false,
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
    },
})

vim.g.minipairs_disable = true

vim.keymap.set("n", "<leader>p", function()
    vim.g.minipairs_disable = not vim.g.minipairs_disable
end, { desc = "Toggle MiniPairs" })

--: }}}

--: sessions {{{
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
--: }}}

--: ai {{{

-- TODO dif doesn't work if end of function is more than 50 lines away.
-- figure out what 'cover' and all that does. feels like if function
-- definition is right above you mini.ai should be able to figure things out
-- try cina, cila. need to get these under my fingers
-- local spec_treesitter = require("mini.ai").gen_spec.treesitter
-- require("mini.ai").setup({
--     n_lines = 100,
--     -- search_method = "cover_or_nearest",
--     custom_textobjects = {
--         f = require("mini.ai").gen_spec.treesitter({
--             a = "@function.outer",
--             i = "@function.inner",
--         }),
--         B = function()
--             local from = { line = 1, col = 1 }
--             local to = {
--                 line = vim.fn.line("$"),
--                 col = math.max(vim.fn.getline("$"):len(), 1),
--             }
--             return { from = from, to = to }
--         end,
--     },
-- })
--: }}}

--: pick {{{

require("mini.pick").setup({
    window = {
        prompt_prefix = "❯ ",
        config = {
            border = "none",
            height = 10,
            width = 50,
        },
    },
})

vim.keymap.set("n", "<leader>f", function()
    MiniPick.builtin.files()
end, { desc = "Pick [F]iles" })
vim.keymap.set("n", "<leader>G", function()
    MiniPick.builtin.grep_live()
end, { desc = "Live [G]rep" })
vim.keymap.set("n", "<leader>h", function()
    MiniPick.builtin.help()
end, { desc = "Pick [H]elp" })

-- : }}}

--: cmdline {{{

require("mini.cmdline").setup()

-- : }}}

--: files {{{

-- require('mini.files').setup()
-- vim.keymap.set('n', '-', function()
--     MiniFiles.open()
-- end, { desc = 'Open Mini Files' })

--: }}}

--: operators {{{

-- require("mini.operators").setup({
--     replace = {
-- 	prefix = "g<c-r>",
-- 	-- Whether to reindent new text to match previous indent
-- 	reindent_linewise = true,
--     },
--     -- Each entry configures one operator.
--     -- `prefix` defines keys mapped during `setup()`: in Normal mode
--     -- to operate on textobject and line, in Visual - on selection.
--
--     -- Evaluate text and replace with output
--     -- evaluate = {
--     --     -- prefix = 'g=',
--     --     prefix = '',
--     -- },
--     -- exchange = {
--     --     prefix = 'gx',
--     --     -- Whether to reindent new text to match previous indent
--     --     reindent_linewise = true,
--     -- },
--     -- -- Multiply (duplicate) text
--     -- multiply = {
--     --     prefix = 'gm',
--     --     -- Function which can modify text before multiplying
--     --     func = nil,
--     -- },
--     -- Replace text with register
--
--     -- Sort text
--     -- sort = {
--     --     prefix = '',
--     --     -- prefix = 'gs',
--     --
--     --     -- Function which does the sort
--     --     func = nil,
--     -- },
-- }) -- gr, g=, gx, gm, gs

--: }}}

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

_G.Config = {}
_G.Config.leader_group_clues = {
    { mode = "n", keys = "<Leader>a", desc = "AI" },
    { mode = "x", keys = "<Leader>a", desc = "AI" },
    { mode = "n", keys = "<Leader>g", desc = "Git" },
    { mode = "n", keys = "<Leader>l", desc = "Lsp" },
    { mode = "x", keys = "<Leader>l", desc = "Lsp" },
    { mode = "n", keys = "<Leader>o", desc = "Org" },
    { mode = "n", keys = "<Leader>q", desc = "Persistence" },
    { mode = "n", keys = "<Leader>s", desc = "Sessions" },
    { mode = "n", keys = "<Leader>d", desc = "Debug" },
}

-- local miniclue = require("mini.clue")
-- -- stylua: ignore
-- miniclue.setup({
--     -- Define which clues to show. By default shows only clues for custom mappings
--     -- (uses `desc` field from the mapping; takes precedence over custom clue).
--     window = {
--       delay = 300,
--       config = { anchor = 'SW', border = "none", row = 'auto', col = 'auto' },
--     --   config = {
--     --     width = vim.fn.winwidth(0) / 2,
--     -- }
--     },
--     clues = {
--       -- This is defined in 'plugin/20_keymaps.lua' with Leader group descriptions
--       Config.leader_group_clues,
--       miniclue.gen_clues.builtin_completion(),
--       miniclue.gen_clues.g(),
--       miniclue.gen_clues.marks(),
--       -- This creates a submode for window resize mappings. Try the following:
--       miniclue.gen_clues.registers(),
--       -- - Press `<C-w>s` to make a window split.
--       -- - Press `<C-w>+` to increase height. Clue window still shows clues as if
--       --   `<C-w>` is pressed again. Keep pressing just `+` to increase height.
--       --   Try pressing `-` to decrease height.
--       -- - Stop submode either by `<Esc>` or by any key that is not in submode.
--       miniclue.gen_clues.windows({ submode_resize = true }),
--       miniclue.gen_clues.z(),
--     },
--     -- Explicitly opt-in for set of common keys to trigger clue window
--     triggers = {
--       { mode = 'n', keys = '<Leader>' }, -- Leader triggers
--       { mode = 'x', keys = '<Leader>' },
--       { mode = 'n', keys = '\\' },       -- mini.basics
--       { mode = 'n', keys = '[' },        -- mini.bracketed
--       { mode = 'n', keys = ']' },
--       { mode = 'x', keys = '[' },
--       { mode = 'x', keys = ']' },
--       { mode = 'i', keys = '<C-x>' },    -- Built-in completion
--       { mode = 'n', keys = 'g' },        -- `g` key
--       { mode = 'x', keys = 'g' },
--       { mode = 'n', keys = "'" },        -- Marks
--       { mode = 'n', keys = '`' },
--       { mode = 'x', keys = "'" },
--       { mode = 'x', keys = '`' },
--       { mode = 'n', keys = '"' },        -- Registers
--       { mode = 'x', keys = '"' },
--       { mode = 'i', keys = '<C-r>' },
--       { mode = 'c', keys = '<C-r>' },
--       { mode = 'n', keys = '<C-w>' },    -- Window commands
--       { mode = 'n', keys = 'z' },        -- `z` key
--       { mode = 'x', keys = 'z' },
--     },
--   })
