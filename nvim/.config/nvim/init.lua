-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins if $luadir/plugins exists
if vim.loop.fs_stat(vim.fn.stdpath('config') .. '/lua/custom/plugins') then
        require('lazy').setup('custom.plugins', {
            defaults = { lazy = true },
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
end

vim.cmd [[ set statusline=%!v:lua.require'custom.statusline'.line() ]]
