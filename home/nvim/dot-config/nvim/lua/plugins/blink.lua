vim.pack.add({
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.0") },
})

require("blink.cmp").setup({

    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "default" },

    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
    },

    signature = {
        enabled = true,
    },

    completion = {
        documentation = { auto_show = true },
        menu = { scrolloff = 0 },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        -- per_filetype = {
        --     lua = { inherit_defaults = true, "lazydev" },
        -- },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
        },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
})
