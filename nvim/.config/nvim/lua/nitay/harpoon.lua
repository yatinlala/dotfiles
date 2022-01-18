require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" }
    },
})

require("telescope").load_extension('harpoon')

local map = vim.api.nvim_set_keymap

map('n', '<leader>ma', ':lua require("harpoon.mark").add_file()', {noremap = true})
map('n', '<leader>mm', ':lua require("harpoon.ui").toggle_quick_menu()', {noremap = true})
map('n', '<leader>mj', ':lua require("harpoon.ui").nav_file(1)', {noremap = true})
map('n', '<leader>mk', ':lua require("harpoon.ui").nav_file(2)', {noremap = true})
map('n', '<leader>ml', ':lua require("harpoon.ui").nav_file(3)', {noremap = true})
map('n', '<leader>m;', ':lua require("harpoon.ui").nav_file(4)', {noremap = true})
