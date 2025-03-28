return { -- Autocompletion
    'hrsh7th/nvim-cmp',
    enabled = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
            dependencies = {
                -- `friendly-snippets` contains a variety of premade snippets.
                --    See the README about individual language/framework/plugin snippets:
                --    https://github.com/rafamadriz/friendly-snippets
                -- {
                --   'rafamadriz/friendly-snippets',
                --   config = function()
                --     require('luasnip.loaders.from_vscode').lazy_load()
                --   end,
                -- },
            },
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
    },
    config = function()
        -- See `:help cmp`
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        luasnip.config.setup({})

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },

            -- performance = {
            --     throttle = 500,
            -- },
            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert({
                -- Select the [n]ext item
                ['<C-n>'] = cmp.mapping.select_next_item(),
                -- Select the [p]revious item
                ['<C-p>'] = cmp.mapping.select_prev_item(),

                -- Scroll the documentation window [b]ack / [f]orward
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                -- Accept the completion.
                --  This will auto-import if your LSP supports it.
                --  This will expand snippets if the LSP sent a snippet.
                ['<C-Space>'] = cmp.mapping.confirm({ select = true }),

                -- Force the completion menu to appear
                ['<C-y>'] = cmp.mapping.complete({}),

                -- Think of <c-l> as moving to the right of your snippet expansion.
                --  So if you have a snippet that's like:
                --  function $name($args)
                --    $body
                --  end
                --
                -- <c-l> will move you to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            }),
            sources = {
                { name = 'lazydev', group_index = 0 },
                { name = 'nvim_lsp' },
                -- { name = 'codeium' },
                { name = 'luasnip' },
                { name = 'path' },
            },
        })
    end,
}

-- local M = {
--     'hrsh7th/nvim-cmp',
--     event = 'InsertEnter',
--     dependencies = {
--         'hrsh7th/cmp-buffer',
--         'hrsh7th/cmp-path',
--         'hrsh7th/cmp-emoji',
--         'hrsh7th/cmp-nvim-lua',
--         'hrsh7th/cmp-nvim-lsp',
--         'saadparwaiz1/cmp_luasnip',
--         -- 'hrsh7th/cmp-cmdline',
--         -- 'dmitmel/cmp-cmdline-history',
--         'hrsh7th/cmp-path',
--     },
-- }
--
-- function M.config()
--     vim.o.completeopt = 'menuone,noselect'
--
--     -- Setup nvim-cmp.
--     local cmp = require('cmp')
--
--     cmp.setup({
--         completion = {
--             completeopt = 'menu,menuone,noinsert',
--         },
--         snippet = {
--             expand = function(args)
--                 require('luasnip').lsp_expand(args.body)
--             end,
--         },
--         mapping = cmp.mapping.preset.insert({
--             -- I think the C-n (next), C-p (prev), and C-y (disable) are enabled by default
--             ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--             ['<C-f>'] = cmp.mapping.scroll_docs(4),
--             ['<C-y>'] = cmp.mapping.complete(),
--             ['<C-e>'] = cmp.mapping.abort(),
--             ['<C-Space>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         }),
--         sources = cmp.config.sources({
--             { name = 'nvim_lua' },
--             { name = 'nvim_lsp' },
--             { name = 'luasnip', max_item_count = 5 },
--             { name = 'codeium' },
--             { name = 'path' },
--             { name = 'emoji' },
--             { name = 'orgmode' },
--             { name = 'buffer', keyword_length = 5 },
--         }),
--         formatting = {
--             format = function(_entry, vim_item)
--                 local icons = {
--                     Class = ' ',
--                     Codeium = '',
--                     Color = ' ',
--                     Constant = ' ',
--                     Constructor = ' ',
--                     Enum = '了 ',
--                     EnumMember = ' ',
--                     Field = '󰜢 ',
--                     File = ' ',
--                     Folder = ' ',
--                     Function = ' ',
--                     Interface = 'ﰮ ',
--                     Keyword = ' ',
--                     Method = 'ƒ ',
--                     Property = ' ',
--                     Snippet = ' ',
--                     Struct = ' ',
--                     Text = ' ',
--                     Unit = ' ',
--                     Value = '󰎠 ',
--                     Variable = ' ',
--                 }
--                 if icons[vim_item.kind] then
--                     vim_item.kind = icons[vim_item.kind] .. vim_item.kind
--                 end
--                 return vim_item
--             end,
--         },
--     })
--
--     -- cmp.setup.cmdline(':', {
--     --     mapping = cmp.mapping.preset.cmdline(),
--     --     sources = cmp.config.sources({
--     --         { name = 'path' },
--     --     }, {
--     --         {
--     --             name = 'cmdline',
--     --             option = {
--     --                 ignore_cmds = { 'Man', '!' },
--     --             },
--     --         },
--     --     }),
--     -- })
--     -- -- `/` cmdline setup.
--     -- cmp.setup.cmdline('/', {
--     --     mapping = cmp.mapping.preset.cmdline(),
--     --     sources = {
--     --         { name = 'buffer' },
--     --     },
--     -- })
-- end
--
-- return M
