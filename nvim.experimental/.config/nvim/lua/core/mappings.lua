local utils = require "core.utils"

local map = utils.map
local cmd = vim.cmd

local M = {}

-- these mappings will only be called during initialization
M.misc = function()
   local function non_config_mappings()
      -- Don't copy the replaced text after pasting in visual mode
      map("v", "p", "p:let @+=@0<CR>")

      -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
      -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
      -- empty mode is same as using :map
      -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
      map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
      map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
      map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
      map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

      -- yank from current cursor to end of line
      map("n", "Y", "yg$")
   end

   local function optional_mappings()
      -- don't yank text on cut ( x )
    map({ "n", "v" }, "x", '"_x')

    map("i", "<C-h>", "<Left>")
    map("i", "<C-e>", "<End>")
    map("i", "<C-l>", "<Right>")
    map("i", "<C-k>", "<Up>")
    map("i", "<C-j>", "<Down>")
    map("i", "<C-a>", "<ESC>^i")

      -- easier navigation between windows
    map("n", "<C-h>", "<C-w>h")
    map("n", "<C-l>", "<C-w>l")
    map("n", "<C-k>", "<C-w>k")
    map("n", "<C-j>", "<C-w>j")
   end

   local function required_mappings()
      map("n", "<leader>ch", ":lua require('nvchad.cheatsheet').show() <CR>") -- show keybinds
      map("n", "<C-S-y>", ":%y+ <CR>") -- copy whole file content
      map("n", "<leader>n", ":set nu! <CR>")
      map("n", "<leader>rn", ":set rnu! <CR>") -- relative line numbers

      -- hide a term from within terminal mode
      map("t", "JK", "<C-\\><C-n> :lua require('core.utils').close_buffer() <CR>")
      -- pick a hidden term
      map("n", "<leader>W", ":Telescope terms <CR>")
      -- Open terminals
      -- TODO this opens on top of an existing vert/hori term, fixme
      map("n", "<leader>h", ":execute 15 .. 'new +terminal' | let b:term_type = 'hori' | startinsert <CR>")
      map("n", "<leader>v", ":execute 'vnew +terminal' | let b:term_type = 'vert' | startinsert <CR>")
      map("n", "<leader>w", ":execute 'terminal' | let b:term_type = 'wind' | startinsert <CR>")
      -- terminal mappings end --

      -- Add Packer commands because we are not loading it at startup
      cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
      cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
      cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
      cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
      cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
      cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"
   end

   non_config_mappings()
   optional_mappings()
   required_mappings()
end

-- below are all plugin related mappings

M.bufferline = function()
   map("n", "<S-l>", ":BufferLineCycleNext <CR>")
   map("n", "<S-h>", ":BufferLineCyclePrev <CR>")
end

M.lspconfig = function()
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
   map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
   map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
   map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
   map("n", "jk", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
   map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
   map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
   map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
   map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
   map("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<CR>")
   map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
   map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
   map("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
   map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
   map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
   map("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
   map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

M.nvimtree = function()
   map("n", "<leader>e", ":NvimTreeToggle <CR>")
end

M.telescope = function()
   map("n", "<leader>fb", ":Telescope buffers <CR>")
   map("n", "<leader>ff", ":Telescope find_files <CR>")
   map("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>")
   map("n", "<leader>cm", ":Telescope git_commits <CR>")
   map("n", "<leader>gt", ":Telescope git_status <CR>")
   map("n", "<leader>fh", ":Telescope help_tags <CR>")
   map("n", "<leader>fw", ":Telescope live_grep <CR>")
   map("n", "<leader>fo", ":Telescope oldfiles <CR>")
   map("n", "<leader>th", ":Telescope themes <CR>")
end

return M
