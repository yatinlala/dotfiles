local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},
	event = "BufReadPost",
}

M.tools = {
	-- "prettierd",
	"stylua",
	-- "selene",
	-- "luacheck",
	-- "eslint_d",
	"shellcheck",
	-- "deno",
	-- "shfmt",
	-- "black",
	-- "isort",
	-- "flake8",
}

function M.check()
	local mr = require("mason-registry")
	for _, tool in ipairs(M.tools) do
		local p = mr.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end

function M.config()
	require("mason").setup()
	M.check()
	require("mason-lspconfig").setup({ automatic_installation = true })
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	local on_attach = function(client, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		-- vim.keymap.set({ "n", "i" }, "<S-k>", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
		vim.keymap.set("n", "<space>d", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<space>la", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
		-- vim.keymap.set("n", "<space>lf", function()
		-- 	vim.lsp.buf.format({ async = true })
		-- end, bufopts)

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = false,
			underline = true,
			signs = true,
		})
		-- require('config.autocmds').lsp_hov_highlight()
		-- require("config.autocmds").lsp_hov_diagnostics()

		-- require('nvim-navic').attach(client, bufnr)
	end

	-- Use a loop to conveniently call 'setup' on multiple servers and
	-- map buffer local keybindings when the language server attaches
	local servers = { "cssls", "bashls", "pyright", "ocamllsp" }
	for _, lsp in pairs(servers) do
		require("lspconfig")[lsp].setup({
			on_attach = on_attach,
		})
	end

	require("lspconfig").lua_ls.setup({
		on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "awesome", "client" },
				},
			},
		},
	})

	-- require('lspconfig')['pyright'].setup{
	--     on_attach = on_attach,
	-- }
	-- require('lspconfig')['tsserver'].setup{
	--     on_attach = on_attach,
	-- }
	-- require('lspconfig')['rust_analyzer'].setup{
	--     on_attach = on_attach,
	--     -- Server-specific settings...
	--     settings = {
	--       ["rust-analyzer"] = {}
	--     }
	-- }
end

return M
