pcall(function()
    vim.loader.enable()
end)

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Setup lazy.nvim
if vim.loop.fs_stat(vim.fn.stdpath('config') .. '/lua/custom/plugins') then
    require('lazy').setup({
        spec = {
            { import = 'custom.plugins' }, -- import your plugins
        },
        defaults = { lazy = true },
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
        checker = { enabled = false }, -- automatically check for plugin updates
        debug = false,
        change_detection = {
            notify = false,
        },
    })
end

vim.cmd([[ set statusline=%!v:lua.require'custom.statusline'.line() ]])
