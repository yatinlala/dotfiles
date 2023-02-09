local M = {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },

    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-web-devicons" },
        { "nvim-telescope/telescope-fzy-native.nvim" },
        { "debugloop/telescope-undo.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "nvim-telescope/telescope-symbols.nvim" },
        { "p00f/nvim-ts-rainbow" },
    },
}

function M.config()
    -- local trouble = require("trouble.providers.telescope")
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },
            file_sorter = require("telescope.sorters").get_fzy_sorter,
            color_devicons = true,
        },
        pickers = {
            find_files = {
                follow = true,
            },
        },
        extensions = {},
        mappings = {
            -- i = { ["<c-t>"] = trouble.open_with_trouble },
            -- n = { ["<c-t>"] = trouble.open_with_trouble },
        },
    })
    require("telescope").load_extension("fzy_native")
    require("telescope").load_extension("projects")
    require("telescope").load_extension("undo")

    require("nvim-treesitter.configs").setup {
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        }
    }
end

M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "< vimrc >",
        cwd = "~/.dotfiles/nvim/.config/nvim/",
    })
end

return M
