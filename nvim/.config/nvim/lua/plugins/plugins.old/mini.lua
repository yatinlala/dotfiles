return {
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    -- {
    --     'echasnovski/mini.ai',
    --     version = '*',
    --     opts = {},
    --     keys = { "ca", "ci", "va", "vi", "da", "di", "ya", "yi" }
    -- },

    -- {
    --     'echasnovski/mini.align',
    --     version = false,
    --     config = true,
    --     keys = 'ga',
    -- },
    -- {
    -- 	"echasnovski/mini.indentscope",
    -- 	version = false,
    -- 	config = function()
    -- 		require("mini.indentscope").setup()
    -- 	end,
    -- 	event = "VeryLazy",
    -- },
    {
        'echasnovski/mini.move',
        version = false,
        opts = {},
        keys = {
            { '<M-h>', mode = { 'n', 'v' } },
            { '<M-j>', mode = { 'n', 'v' } },
            { '<M-k>', mode = { 'n', 'v' } },
            { '<M-l>', mode = { 'n', 'v' } },
        },
    },

    -- {
    -- 	"echasnovski/mini.sessions",
    -- 	version = "*",
    -- 	config = function()
    -- 		require("mini.sessions").setup()
    -- 	end,
    -- 	lazy = false,
    -- },
    -- {
    -- 	"echasnovski/mini.starter",
    -- 	version = "*",
    -- 	config = function()
    -- 		require("mini.starter").setup()
    -- 	end,
    -- 	lazy = false,
    -- },
}

-- return { -- Collection of various small independent plugins/modules
--         'echasnovski/mini.nvim',
--         lazy = false,
--         config = function()
--
--             -- Add/delete/replace surroundings (brackets, quotes, etc.)
--             --
--             -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--             -- - sd'   - [S]urround [D]elete [']quotes
--             -- - sr)'  - [S]urround [R]eplace [)] [']
--             -- require('mini.surround').setup()
--
--             -- Simple and easy statusline.
--             --  You could remove this setup call if you don't like it,
--             --  and try some other statusline plugin
--             local statusline = require('mini.statusline')
--             -- set use_icons to true if you have a Nerd Font
--             statusline.setup()
--
--             -- You can configure sections in the statusline by overriding their
--             -- default behavior. For example, here we set the section for
--             -- cursor location to LINE:COLUMN
--             ---@diagnostic disable-next-line: duplicate-set-field
--             statusline.section_location = function()
--                 return '%2l:%-2v'
--             end
--
--             -- ... and there is more!
--             --  Check out: https://github.com/echasnovski/mini.nvim
--         end,
-- }
