local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-emoji",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-cmdline",
		"dmitmel/cmp-cmdline-history",
		"hrsh7th/cmp-path",
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
		performance = {
			-- debounce = 500,
			throttle = 500,
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			-- I think the C-n (next), C-p (prev), and C-y (disable) are enabled by default
			["<C-Space>"] = cmp.mapping.confirm({ select = false }),
			["<C-e>"] = cmp.mapping.close(),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lua" },
			{ name = "nvim_lsp" },
			{ name = "luasnip", max_item_count = 5 },
			{ name = "buffer", keyword_length = 5 },
			{ name = "path" },
			{ name = "emoji" },
			{ name = "neorg" },
		}),
		formatting = {
			format = function(_entry, vim_item)
				local icons = {
					Class = " ",
					Color = " ",
					Constant = " ",
					Constructor = " ",
					Enum = "了 ",
					EnumMember = " ",
					Field = " ",
					File = " ",
					Folder = " ",
					Function = " ",
					Interface = "ﰮ ",
					Keyword = " ",
					Method = "ƒ ",
					Property = " ",
					Snippet = "﬌ ",
					Struct = " ",
					Text = " ",
					Unit = " ",
					Value = " ",
					Variable = " ",
				}
				if icons[vim_item.kind] then
					vim_item.kind = icons[vim_item.kind] .. vim_item.kind
				end
				return vim_item
			end,
		},
	})
end

return M
