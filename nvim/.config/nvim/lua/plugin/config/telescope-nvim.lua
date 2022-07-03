local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local trouble = require("trouble.providers.telescope")
local telescope = require("telescope")

telescope.setup {
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        color_devicons = true
    },
    pickers = {
        find_files = {
            follow = true
        }
    },
    extensions = {
    },
    mappings = {
        i = { ["<c-t>"] = trouble.open_with_trouble },
        n = { ["<c-t>"] = trouble.open_with_trouble },


    },
}
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('projects')

local M = {}
M.search_dotfiles = function()
    require('telescope.builtin').find_files({
        prompt_title = "< vimrc >",
        cwd = "~/.dotfiles/nvim/.config/nvim/",
    })
end

return M
