require("telescope").setup {
  defaults = {
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      color_devicons = true

  },
  pickers = {
    find_files = {
        follow = true
    }
  },
  extensions = {
  }
}
require('telescope').load_extension('fzy_native')

local M = {}
M.search_dotfiles = function()
    require('telescope.builtin').find_files({
        prompt_title = "< vimrc >",
        cwd = "~/.dotfiles/nvim/.config/nvim/",
        })
end

return M
