return {
    -- {
    --     -- TODO dupe with textobjects?
    --     'echasnovski/mini.ai',
    --     version = '*',
    --     config = true,
    --     event = 'CursorMoved',
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
        config = true,
        keys = { '<M-h>', '<M-j>', '<M-k>', '<M-l>' },
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

    -- {
    -- 	-- gS toggles b/t function args on one line and function args with one arg per line
    -- 	"echasnovski/mini.splitjoin",
    -- 	version = false,
    -- 	config = function()
    -- 		require("mini.splitjoin").setup()
    -- 	end,
    -- 	keys = 'gS',
    -- },
}
