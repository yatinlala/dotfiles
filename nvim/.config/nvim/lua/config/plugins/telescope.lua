local M = {
  'nvim-telescope/telescope.nvim',
  cmd = { 'Telescope' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'nvim-telescope/telescope-fzy-native.nvim' },
    { 'debugloop/telescope-undo.nvim' },
    { 'nvim-telescope/telescope-project.nvim' },
    { 'nvim-telescope/telescope-symbols.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
  },
}

function M.config()
  -- local trouble = require("trouble.providers.telescope")
  local telescope = require 'telescope'

  telescope.setup {
    defaults = {
      prompt_prefix = '  ',
      selection_caret = ' ',
      path_display = { 'smart' },
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      color_devicons = true,
    },
    pickers = {
      find_files = {
        follow = true,
      },
    },
    extensions = {
      file_browser = {
        -- theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        prompt_path = true,
        cwd_to_path = true,
        hidden = true,
        mappings = {
          ['i'] = {
            -- your custom insert mode mappings
            -- ["<BS>"] = ,
          },
          ['n'] = {
            -- your custom normal mode mappings
          },
        },
      },
    },
    mappings = {
      -- i = { ["<c-t>"] = trouble.open_with_trouble },
      -- n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  }
  require('telescope').load_extension 'fzy_native'
  require('telescope').load_extension 'projects'
  require('telescope').load_extension 'undo'
  require('telescope').load_extension 'file_browser'
end

return M
