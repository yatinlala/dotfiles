vim.cmd("command! -nargs=? -complete=dir Lf :lua require('util').Lf(<f-args>)")

vim.cmd("command! -nargs=? -complete=dir Lazygit :lua require('util').Lazygit(<f-args>)")

vim.api.nvim_create_user_command('ToggleBackground', require('util').toggleBg, {})

vim.api.nvim_create_user_command('OpenGithubRepo', function(_)
  local ghpath = vim.api.nvim_eval("shellescape(expand('<cfile>'))")
  local formatpath = ghpath:sub(2, #ghpath - 1)
  local repourl = 'https://www.github.com/' .. formatpath
  vim.fn.system({ 'xdg-open', repourl })
end, {
  desc = 'Open Github Repo',
  force = true,
})
