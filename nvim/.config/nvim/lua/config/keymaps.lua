local opts = { noremap = true, silent = true }

local wk = require("which-key")

-- Normal --

-- Clear search highlights
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

-- Don't yank on x
vim.keymap.set("n", "x", '"_x', opts)
-- Sensible split movement
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Centered searches
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
-- Centered half page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
-- Centered line cat
vim.keymap.set("n", "J", "mzJ'z", opts)

vim.keymap.set("n", "<c-\\>", ":ToggleTerm<CR>", {})

vim.keymap.set("n", "gf", ":e <cfile><CR>", opts)

vim.keymap.set("n","<c-p>", ":lua require('telescope.builtin').find_files()<cr>")

-- -- Smart(ish) compilation
-- vim.keymap.set('n', '<leader>c',  ':w! \\| !comp <c-r>%<CR><CR>', {})
-- -- Enable spell checking
-- vim.keymap.set('n', '<leader><leader>s', ':setlocal spell! spelllang=en_us<CR>', {})

-- Insert --
-- Undo break points
vim.keymap.set("i", ",", ",<c-g>u", opts)
vim.keymap.set("i", ".", ".<c-g>u", opts)
vim.keymap.set("i", "(", "(<c-g>u", opts)

-- Adjust bullet level
vim.keymap.set("i", "<C-g>", "<esc><<A", opts)
vim.keymap.set("i", "<C-h>", "<esc>>>A", opts)

vim.keymap.set("i", "<C-<BS>>", "<C-w>", opts)

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Don't override copy register when pasting into highlight
vim.keymap.set("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down and indent it
vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", opts)

-- Command --
-- Force save a sudoer file
vim.keymap.set("c", "w!!", "w !sudo tee %", {})

local leader = {
	b = {
		function()
			require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false }))
		end,
		"buffers",
	},
	c = { "<cmd>ColorizerToggle<CR>", "toggle colorizer" },
	C = { require("util").toggleBg, "toggle dark/light" },
	D = {
		name = "Duck",
		h = { "<cmd>lua require('duck').hatch()<CR>", "Hatch a duck" },
		k = { "<cmd>lua require('duck').cook()<CR>", "Cook the duck" },
	},
	e = {
		function()
			_lf_toggle()
		end,
		"Lf",
	},
	f = {
		name = "Telescope",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		B = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		h = { "<cmd>:Telescope help_tags<CR>", "help tags" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		u = { "<cmd>Telescope undo<cr>", "Undo" },
		n = { "<cmd>:Telescope find_files cwd=~/.config/nvim<CR>", "edit neovim" },
		p = { require("telescope").extensions.projects.projects, "projects" },
		r = { "<cmd>:Telescope oldfiles<CR>", "recent files" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		s = {
			":lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji'} }<cr>",
			"recent files",
		},

		[":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
		t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
		S = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
		l = { vim.show_pos, "Highlight Groups at cursor" },
		f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
		o = { "<cmd>:Telescope vim_options<cr>", "Options" },
		a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
	},
	F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
	["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
	["."] = { ":Telescope file_browser<CR>", "Browse Files" },
	g = {
		name = "Git",
		g = {
			function()
				_lazygit_toggle()
			end,
			"Lazygit",
		},
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
		--     d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
	},
	l = {
		name = "LSP",
		-- a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = {
			"<cmd>Telescope lsp_document_diagnostics<cr>",
			"Document Diagnostics",
		},
		w = {
			"<cmd>Telescope lsp_workspace_diagnostics<cr>",
			"Workspace Diagnostics",
		},
		f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
		j = {
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		o = { "<cmd>:SymbolsOutline<CR>", "Symbols Outline" },
		q = { "<cmd>lua vim.diagnostic.setloclist({ open = false })<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
	},
	L = { "<cmd>:Lazy<cr>", "Lazy" },
	n = {
		":ene <BAR> startinsert <CR>",
		"new file",
	},
	q = {
		name = "Quickfix",
		l = { "<cmd>lopen<cr>", "Open Location List" },
		q = { "<cmd>copen<cr>", "Open Quickfix List" },
	},
	t = {
		name = "Terminal",
		f = { "<cmd>ToggleTerm direction=float<cr>", "Term Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Term Horizontal" },
		-- p = { _PYTHON_TOGGLE(), "Python" },
		t = { "<cmd>ToggleTerm direction=tab<cr>", "Term Tab" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Term Vertical" },
	},
	u = {
		"<cmd>:Telescope undo<CR>",
		"Undo",
	},
	w = {
		name = "Vimwiki",
		w = { "<cmd>e ~/documents/wiki/index.<cr>", "Wiki Index" },
	},
	--   t = {
	--     name = "toggle",
	--     f = {
	--       require("config.plugins.lsp.formatting").toggle,
	--       "Format on Save",
	--     },
	--     s = {
	--       function()
	--         util.toggle("spell")
	--       end,
	--       "Spelling",
	--     },
	--     w = {
	--       function()
	--         util.toggle("wrap")
	--       end,
	--       "Word Wrap",
	--     },
	--     n = {
	--       function()
	--         util.toggle("relativenumber", true)
	--         util.toggle("number")
	--       end,
	--       "Line Numbers",
	--     },
	--   },
	--   ["<tab>"] = {
	--     name = "tabs",
	--     ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
	--     n = { "<cmd>tabnext<CR>", "Next" },
	--     d = { "<cmd>tabclose<CR>", "Close" },
	--     p = { "<cmd>tabprevious<CR>", "Previous" },
	--     ["]"] = { "<cmd>tabnext<CR>", "Next" },
	--     ["["] = { "<cmd>tabprevious<CR>", "Previous" },
	--     f = { "<cmd>tabfirst<CR>", "First" },
	--     l = { "<cmd>tablast<CR>", "Last" },
	--   },
}

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto" } })
