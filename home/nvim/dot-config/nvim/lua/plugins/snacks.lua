return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<leader>f",
            function()
                -- Snacks.picker.files()
                Snacks.picker.smart()
            end,
            desc = "Pick [F]iles",
        },
        {
            "<leader>h",
            function()
                Snacks.picker.help()
            end,
            desc = "Pick [H]elp",
        },
        {
            "<leader>G",
            function()
                Snacks.picker.grep()
            end,
            desc = "Live [G]rep",
        },
        {
            "<leader>bd",
            function()
                Snacks.bufdelete()
            end,
            desc = "[B]uffer [D]elete",
        },
        {
            "<leader>ba",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "Delete [B]uffer [A]ll",
        },
    },
    opts = {
        bigfile = { enabled = true },
        image = {
            enabled = true,
            doc = {
                inline = false,
                max_width = 40,
                max_height = 20,
            },
        },
        indent = {
            enabled = true,
            char = "┆", -- TODO doesn't work?
            animate = { enabled = false },
        },
        quickfile = { enabled = true },
        picker = {
            layout = {
                preset = "telescope",
            },
        },
    },
}
