-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- load plugins
require('lazy').setup('plugins', {
    -- defaults = { lazy = true },
    install = { colorscheme = { 'gruvbox.nvim' } },
    checker = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'zip',
                'zipPlugin',
                'fzf',
                'tar',
                'tarPlugin',
                'getscript',
                'getscriptPlugin',
                'vimball',
                'vimballPlugin',
                '2html_plugin',
                'matchit',
                'matchparen',
                'logiPat',
                'rrhelper',
                'netrw',
                'netrwPlugin',
                'netrwSettings',
                'netrwFileHandlers',
                'tohtml',
                -- 'tutor',
            },
        },
    },
    debug = false,
})
