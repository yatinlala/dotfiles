-- Jump plugin
return {
    "folke/flash.nvim",
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
    },
    opts = {
        modes = {
            char = {
                enabled = false, -- override, f,F,t,T, etc.
            },
        },
        prompt = {
            enabled = false, -- show flash icon at bottom
        },
        remote_op = {
            restore = false,
            motion = false,
        },
    },
}
