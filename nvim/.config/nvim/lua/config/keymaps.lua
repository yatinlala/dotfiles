local opts = { noremap = true, silent = true }

local map = vim.keymap.set
local wk = require("which-key")

-- Normal --

-- Clear search highlights
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

-- Don't yank on x
map("n", "x", '"_x', opts)
-- Sensible split movement
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Centered searches
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
-- Centered half page movements
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
-- Centered line cat
map("n", "J", "mzJ'z", opts)

map("n", "<c-\\>", ":ToggleTerm<CR>", {})

map("n", "gf", ":e <cfile><CR>", opts)

-- -- Smart(ish) compilation
-- map('n', '<leader>c',  ':w! \\| !comp <c-r>%<CR><CR>', {})
-- -- Enable spell checking
-- map('n', '<leader><leader>s', ':setlocal spell! spelllang=en_us<CR>', {})

-- Insert --
-- Undo break points
map("i", ",", ",<c-g>u", opts)
map("i", ".", ".<c-g>u", opts)
map("i", "(", "(<c-g>u", opts)

-- Adjust bullet level
map("i", "<C-f>", "<esc><<A", opts)
map("i", "<C-j>", "<esc>>>A", opts)

map("i", "<C-<BS>>", "<C-w>", opts)

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Don't override copy register when pasting into highlight
map("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down and indent it
map("x", "J", ":move '>+1<CR>gv=gv", opts)
map("x", "K", ":move '<-2<CR>gv=gv", opts)

-- Command --
-- Force save a sudoer file
map("c", "w!!", "w !sudo tee %", {})

-- local opts = {
--     mode = "n", -- NORMAL mode
--     prefix = "<leader>",
--     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--     silent = true, -- use `silent` when creating keymaps
--     noremap = true, -- use `noremap` when creating keymaps
--     nowait = true, -- use `nowait` when creating keymaps
-- }

-- local leader = {
--   ["w"] = {
--     name = "+windows",
--     ["w"] = { "<C-W>p", "other-window" },
--     ["d"] = { "<C-W>c", "delete-window" },
--     ["-"] = { "<C-W>s", "split-window-below" },
--     ["|"] = { "<C-W>v", "split-window-right" },
--     ["2"] = { "<C-W>v", "layout-double-columns" },
--     ["h"] = { "<C-W>h", "window-left" },
--     ["j"] = { "<C-W>j", "window-below" },
--     ["l"] = { "<C-W>l", "window-right" },
--     ["k"] = { "<C-W>k", "window-up" },
--     ["H"] = { "<C-W>5<", "expand-window-left" },
--     ["J"] = { ":resize +5", "expand-window-below" },
--     ["L"] = { "<C-W>5>", "expand-window-right" },
--     ["K"] = { ":resize -5", "expand-window-up" },
--     ["="] = { "<C-W>=", "balance-window" },
--     ["s"] = { "<C-W>s", "split-window-below" },
--     ["v"] = { "<C-W>v", "split-window-right" },
--   },
--   c = {
--     name = "+code",
--   },
--   b = {
--     name = "+buffer",
--     ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
--     ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
--     ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
--     ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
--     ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
--     -- ["D"] = { "<cmd>:bd<CR>", "Delete Buffer & Window" },
--   },
--   g = {
--     name = "+git",
--     l = {
--       function()
--         require("util").float_terminal("lazygit", { border = "none" })
--       end,
--       "LazyGit",
--     },
--     c = { "<Cmd>Telescope git_commits<CR>", "commits" },
--     b = { "<Cmd>Telescope git_branches<CR>", "branches" },
--     s = { "<Cmd>Telescope git_status<CR>", "status" },
--     d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
--     h = { name = "+hunk" },
--   },
--   ["h"] = {
--     name = "+help",
--     t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
--     c = { "<cmd>:Telescope commands<cr>", "Commands" },
--     h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
--     m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
--     k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
--     s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
--     l = { vim.show_pos, "Highlight Groups at cursor" },
--     f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
--     o = { "<cmd>:Telescope vim_options<cr>", "Options" },
--     a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
--     p = {
--       name = "+packer",
--       p = { "<cmd>PackerSync<cr>", "Sync" },
--       s = { "<cmd>PackerStatus<cr>", "Status" },
--       i = { "<cmd>PackerInstall<cr>", "Install" },
--       c = { "<cmd>PackerCompile<cr>", "Compile" },
--     },
--   },
--   s = {
--     name = "+search",
--     g = { "<cmd>Telescope live_grep<cr>", "Grep" },
--     b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
--     s = {
--       function()
--         require("telescope.builtin").lsp_document_symbols({
--           symbols = {
--             "Class",
--             "Function",
--             "Method",
--             "Constructor",
--             "Interface",
--             "Module",
--             "Struct",
--             "Trait",
--             "Field",
--             "Property",
--           },
--         })
--       end,
--       "Goto Symbol",
--     },
--     h = { "<cmd>Telescope command_history<cr>", "Command History" },
--     m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
--     r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
--   },
--   f = {
--     name = "+file",
--     t = { "<cmd>Neotree toggle<cr>", "NeoTree" },
--     f = { "<cmd>Telescope find_files<cr>", "Find File" },
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--     n = { "<cmd>enew<cr>", "New File" },
--     z = "Zoxide",
--     d = "Dot Files",
--   },
--   o = {
--     name = "+open",
--     p = { "<cmd>Peek<cr>", "Peek (Markdown Preview)" },
--     g = { "<cmd>Glow<cr>", "Markdown Glow" },
--     n = { "<cmd>lua require('github-notifications.menu').notifications()<cr>", "GitHub Notifications" },
--   },
--   p = {
--     name = "+project",
--     p = "Open Project",
--     b = { ":Telescope file_browser cwd=~/projects<CR>", "Browse ~/projects" },
--   },
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
--   ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
--   [" "] = "Find File",
--   ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
--   [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
--   ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
--   [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
--   ["C"] = {
--     function()
--       util.clipman()
--     end,
--     "Paste from Clipman",
--   },
--   q = {
--     name = "+quit/session",
--     q = { "<cmd>qa<cr>", "Quit" },
--     ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
--     s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
--     l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
--     d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
--   },
--   x = {
--     name = "+errors",
--     x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
--     t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
--     tt = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo Trouble" },
--     T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
--     l = { "<cmd>lopen<cr>", "Open Location List" },
--     q = { "<cmd>copen<cr>", "Open Quickfix List" },
--   },
--   z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
--   T = {
--     function()
--       util.test(true)
--     end,
--     "Plenary Test File",
--   },
--   D = {
--     function()
--       util.test()
--     end,
--     "Plenary Test Directory",
--   },
-- }

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
		f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "find files" },
		h = { "<cmd>:Telescope help_tags<CR>", "help tags" },
		n = { "<cmd>:Telescope find_files cwd=~/.config/nvim<CR>", "edit neovim" },
		p = { require("telescope").extensions.projects.projects, "projects" },

		r = { "<cmd>:Telescope oldfiles<CR>", "recent files" },
		s = { ":lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji'} }", "recent files" },
	},

	F = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },

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

	-- p = {
	--     name = "Packer",
	--     c = { "<cmd>PackerCompile<cr>", "Compile" },
	--     i = { "<cmd>PackerInstall<cr>", "Install" },
	--     s = { "<cmd>PackerSync<cr>", "Sync" },
	--     S = { "<cmd>PackerStatus<cr>", "Status" },
	--     u = { "<cmd>PackerUpdate<cr>", "Update" },
	-- },

	-- p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },

	q = {
		t = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
		q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
		l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
	},

	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
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
}

-- for i = 0, 10 do
--   leader[tostring(i)] = "which_key_ignore"
-- end

wk.register(leader, { prefix = "<leader>" })

wk.register({ g = { name = "+goto" } })
