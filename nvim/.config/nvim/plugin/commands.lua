-- vim.api.nvim_create_user_command('ToggleBackground', require('custom.util').toggleBg, {})
--
vim.api.nvim_create_user_command('EC', 'e $MYVIMRC', {})

vim.cmd('command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile')
--
-- vim.api.nvim_create_user_command('OpenGithubRepo', function(_)
--     local ghpath = vim.api.nvim_eval("shellescape(expand('<cfile>'))")
--     local formatpath = ghpath:sub(2, #ghpath - 1)
--     local repourl = 'https://www.github.com/' .. formatpath
--     vim.fn.system({ 'xdg-open', repourl })
-- end, {
--     desc = 'Open Github Repo',
--     force = true,
-- })
