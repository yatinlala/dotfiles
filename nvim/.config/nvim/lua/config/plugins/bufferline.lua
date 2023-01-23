return {
	"akinsho/bufferline.nvim",
	event = "BufReadPre",
	config = function()
		require("bufferline").setup({
			options = {
				numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
				close_command = "Sayonara! %d", -- can be a string | function, see "Mouse actions"
				right_mouse_command = "Sayonara! %d", -- can be a string | function, see "Mouse actions"
				left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
				middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
				buffer_close_icon = "",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 20,
				max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
				tab_size = 20,
				diagnostics = false, -- | "nvim_lsp" | "coc",
				diagnostics_update_in_insert = false,
				offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				show_tab_indicators = true,
				persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
				-- can also be a table containing 2 custom separators
				-- [focused and unfocused]. eg: { '|', '|' }
				separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
				enforce_regular_tabs = true,
				always_show_bufferline = true,
				-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
				--   -- add custom logic
				--   return buffer_a.modified > buffer_b.modified
				-- end
			},
			highlights = {
				fill = {
					fg = { attribute = "fg", highlight = "#ff0000" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				background = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},

				-- buffer_selected = {
				--   guifg = {attribute='fg',highlight='#ff0000'},
				--   guibg = {attribute='bg',highlight='#0000ff'},
				--   gui = 'none'
				--   },
				buffer_visible = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},

				close_button = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				close_button_visible = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				-- close_button_selected = {
				--   guifg = {attribute='fg',highlight='TabLineSel'},
				--   guibg ={attribute='bg',highlight='TabLineSel'}
				--   },

				tab_selected = {
					fg = { attribute = "fg", highlight = "Normal" },
					bg = { attribute = "bg", highlight = "Normal" },
				},
				tab = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				tab_close = {
					-- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
					fg = { attribute = "fg", highlight = "TabLineSel" },
					bg = { attribute = "bg", highlight = "Normal" },
				},

				duplicate_selected = {
					fg = { attribute = "fg", highlight = "TabLineSel" },
					bg = { attribute = "bg", highlight = "TabLineSel" },
				},
				duplicate_visible = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				duplicate = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},

				modified = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				modified_selected = {
					fg = { attribute = "fg", highlight = "Normal" },
					bg = { attribute = "bg", highlight = "Normal" },
				},
				modified_visible = {
					fg = { attribute = "fg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},

				separator = {
					fg = { attribute = "bg", highlight = "TabLine" },
					bg = { attribute = "bg", highlight = "TabLine" },
				},
				separator_selected = {
					fg = { attribute = "bg", highlight = "Normal" },
					bg = { attribute = "bg", highlight = "Normal" },
				},
				-- separator_visible = {
				--   guifg = {attribute='bg',highlight='TabLine'},
				--   guibg = {attribute='bg',highlight='TabLine'}
				--   },
				indicator_selected = {
					fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
					bg = { attribute = "bg", highlight = "Normal" },
				},
			},
		})
	end,
}
