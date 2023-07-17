return {
  'akinsho/bufferline.nvim',
  event = 'BufReadPre',
  enabled = true,
  config = function()
    require('bufferline').setup {
      options = {
        style_preset = require('bufferline').style_preset.no_italic,
        buffer_selected = {
          italic = false,
        },
        -- 	max_name_length = 20,
        -- 	max_prefix_length = 20, -- prefix used when a buffer is de-duplicated
        -- 	tab_size = 20,
        -- 	diagnostics = false, -- | "nvim_lsp" | "coc",
        -- 	diagnostics_update_in_insert = false,
        -- 	offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        -- 	show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        -- 	show_tab_indicators = true,
        -- 	persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- 	-- can also be a table containing 2 custom separators
        -- 	-- [focused and unfocused]. eg: { '|', '|' }
        -- 	separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
        -- 	enforce_regular_tabs = true,
        -- 	always_show_bufferline = true,
        -- 	-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        -- 	--   -- add custom logic
        -- 	--   return buffer_a.modified > buffer_b.modified
        -- 	-- end
      },
    }
  end,
}
