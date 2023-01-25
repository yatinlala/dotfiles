return {
    { "lifepillar/vim-gruvbox8" },
    { "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({})
        end,
    },

    { "tamton-aquib/duck.nvim" },
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
            vim.g.matchup_matchparen_deferred = 1
            vim.b.matchup_matchparen_enabled = 0
        end,
    },
    {
        "ethanholz/nvim-lastplace",
        event = "BufWinEnter",
        config = true,
    },

    {
        "nvim-orgmode/orgmode",
        lazy = false,
        config = function()
            require("orgmode").setup_ts_grammar()
            require("orgmode").setup({
                org_agenda_files = "~/documents/org/*",
                org_default_notes_file = "~/documents/org/refile.org",
            })
        end,
    },
    -- {
    --     "Exafunction/codeium.vim",
    --     cmd = "Codeium",
    --     setup = function()
    --         vim.g.codeium_disable_bindings = 1
    --         vim.g.codeium_enabled = false
    --     end,
    --     config = function()
    --         vim.keymap.set("i", "<C-g>", function()
    --             return vim.fn["codeium#Accept"]()
    --         end, { expr = true })
    --         vim.keymap.set("i", "<c-;>", function()
    --             return vim.fn["codeium#CycleCompletions"](1)
    --         end, { expr = true })
    --         vim.keymap.set("i", "<c-,>", function()
    --             return vim.fn["codeium#CycleCompletions"](-1)
    --         end, { expr = true })
    --         vim.keymap.set("i", "<c-x>", function()
    --             return vim.fn["codeium#Clear"]()
    --         end, { expr = true })
    --     end,
    -- },

    --  { "tpope/vim-dispatch" },
    --  { "tpope/vim-sleuth" },
    --  { "tpope/vim-repeat" },
    --  { "tpope/vim-surround" },
    --  { "tpope/vim-unimpaired" },
    --  { "tpope/vim-rhubarb" },
    --  { "tpope/vim-eunuch" },
    --  { "tpope/vim-obsession" },
    --  { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
    --  { "guns/vim-sexp", ft = { "clojure" } },
    --  {
    --    "norcalli/nvim-terminal.lua",
    --    ft = "terminal",
    --    config = function()
    --      require("terminal").setup()
    --    end,
    --  },
    --
    --  {
    --    "folke/persistence.nvim",
    --    event = "BufReadPre",
    --    config = function()
    --      require("persistence").setup({
    --        options = { "buffers", "curdir", "tabpages", "winsize", "help" },
    --      })
    --    end,
    --  },
    --
    --  {
    --    "andymass/vim-matchup",
    --    event = "BufReadPost",
    --    config = function()
    --      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    --    end,
    --  },
}
