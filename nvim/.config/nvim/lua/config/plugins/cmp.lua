-- local check_backspace = function()
--     local col = vim.fn.col "." - 1
--     return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
-- end
--
-- --   פּ ﯟ   some other good icons
-- local kind_icons = {
--     Text = "",
--     Method = "m",
--     Function = "",
--     Constructor = "",
--     Field = "",
--     Variable = "",
--     Class = "",
--     Interface = "",
--     Module = "",
--     Property = "",
--     Unit = "",
--     Value = "",
--     Enum = "",
--     Keyword = "",
--     Snippet = "",
--     Color = "",
--     File = "",
--     Reference = "",
--     Folder = "",
--     EnumMember = "",
--     Constant = "",
--     Struct = "",
--     Event = "",
--     Operator = "",
--     TypeParameter = "",
-- }
--
-- cmp.setup {
--     snippet = {
--         expand = function(args)
--             luasnip.lsp_expand(args.body) -- For `luasnip` users.
--         end,
--     },
--     mapping = {
--         ["<C-p>"] = cmp.mapping.select_prev_item(),
--         ["<C-n>"] = cmp.mapping.select_next_item(),
--         ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--         ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--         ["<C-e>"] = cmp.mapping {
--             i = cmp.mapping.abort(),
--             c = cmp.mapping.close(),
--         },
--         ["<CR>"] = cmp.mapping.confirm { select = false },
--         ["<Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_next_item()
--             elseif luasnip.expandable() then
--                 luasnip.expand()
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             elseif check_backspace() then
--                 fallback()
--             else
--                 fallback()
--             end
--         end, {
--             "i",
--             "s",
--         }),
--         ["<S-Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_prev_item()
--             elseif luasnip.jumpable(-1) then
--                 luasnip.jump(-1)
--             else
--                 fallback()
--             end
--         end, {
--             "i",
--             "s",
--         }),
--     },
--     formatting = {
--         fields = { "abbr", "kind", "menu" },
--         format = function(entry, vim_item)
--             -- Kind icons
--             vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
--             -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
--             vim_item.menu = ({
--                 nvim_lsp = "[LSP]",
--                 nvim_lua = "[Nvim_Lua]",
--                 luasnip = "[Snippet]",
--                 buffer = "[Buffer]",
--                 path = "[Path]",
--             })[entry.source.name]
--             return vim_item
--         end,
--     },
--     sources = {
--         { name = "orgmode" },
--         { name = "nvim_lsp" },
--         { name = "nvim_lua" },
--         { name = "luasnip" },
--         { name = "buffer", max_item_count = 10 },
--         { name = "path" },
--     },
--     confirm_opts = {
--         behavior = cmp.ConfirmBehavior.Replace,
--         select = false,
--     },
--     window = {
--         documentation = {
--             border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
--         }
--     },
--     experimental = {
--         ghost_text = false,
--         native_menu = false,
--     },
-- }
--
-- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })

local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-cmdline",
		"dmitmel/cmp-cmdline-history",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
	},
}

function M.config()
	vim.o.completeopt = "menuone,noselect"

	-- Setup nvim-cmp.
	local cmp = require("cmp")

	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			-- ["<C-Space>"] = cmp.mapping.complete({}),
			["<C-e>"] = cmp.mapping.close(),
			["<C-Space>"] = cmp.mapping.confirm({ select = false }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "emoji" },
			{ name = "neorg" },
		}),
		formatting = {
			format = require("config.plugins.lsp.kind").cmp_format(),
		},
		-- documentation = {
		--   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		--   winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
		-- },
		experimental = {
			-- ghost_text = {
			--   hl_group = "LspCodeLens",
			-- },
		},
		-- sorting = {
		--   comparators = {
		--     cmp.config.compare.sort_text,
		--     cmp.config.compare.offset,
		--     -- cmp.config.compare.exact,
		--     cmp.config.compare.score,
		--     -- cmp.config.compare.kind,
		--     -- cmp.config.compare.length,
		--     cmp.config.compare.order,
		--   },
		-- },
	})

	-- cmp.setup.cmdline(":", {
	--   mapping = cmp.mapping.preset.cmdline(),
	--   sources = cmp.config.sources({
	--     -- { name = "noice_popupmenu" },
	--     { name = "path" },
	--     { name = "cmdline" },
	--     -- { name = "cmdline_history" },
	--   }),
	-- })
end

return M
