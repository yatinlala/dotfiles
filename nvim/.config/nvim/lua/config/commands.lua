vim.api.nvim_create_user_command('ToggleBackground', require('util').toggleBg, {})
vim.cmd("command! -nargs=? -complete=dir Lf :lua require('util').Lf(<f-args>)")
vim.cmd("command! -nargs=? -complete=dir Lazygit :lua require('util').Lazygit(<f-args>)")
