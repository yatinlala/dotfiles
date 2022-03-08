local present, packer = pcall(require, "plugins.packerInit")

if not present then
   return false
end

local override_req = require("core.utils").override_req

local plugins = {
   { "NvChad/extensions" },
   { "nvim-lua/plenary.nvim" },
   { "lewis6991/impatient.nvim" },
   { "nathom/filetype.nvim" },

   {
      "wbthomason/packer.nvim",
      event = "VimEnter",
   },

  {
  "lifepillar/gruvbox8",
  },

   {
      "kyazdani42/nvim-web-devicons",
      after = "gruvbox8",
      config = override_req("nvim_web_devicons", "plugins.configs.icons", "setup"),
   },

   {
      "feline-nvim/feline.nvim",
      after = "nvim-web-devicons",
      config = override_req("feline", "plugins.configs.statusline", "setup"),
   },

   {
      "akinsho/bufferline.nvim",
      after = "nvim-web-devicons",
      config = override_req("bufferline", "plugins.configs.bufferline"),
      setup = function()
         require("core.mappings").bufferline()
      end,
   },

   {
      "lukas-reineke/indent-blankline.nvim",
      event = "BufRead",
      config = override_req("indent_blankline", "plugins.configs.others", "blankline"),
   },

   {
      "NvChad/nvim-colorizer.lua",
      event = "BufRead",
      config = override_req("nvim_colorizer", "plugins.configs.others", "colorizer"),
   },

   {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufRead", "BufNewFile" },
      config = override_req("nvim_treesitter", "plugins.configs.treesitter", "setup"),
      run = ":TSUpdate",
   },

   -- git stuff
   {
      "lewis6991/gitsigns.nvim",
      opt = true,
      config = override_req("gitsigns", "plugins.configs.others", "gitsigns"),
      setup = function()
         require("core.utils").packer_lazy_load "gitsigns.nvim"
      end,
   },

   -- lsp stuff

   {
      "neovim/nvim-lspconfig",
      module = "lspconfig",
      opt = true,
      setup = function()
         require("core.utils").packer_lazy_load "nvim-lspconfig"
         -- reload the current file so lsp actually starts for it
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
      end,
      config = override_req("lspconfig", "plugins.configs.lspconfig"),
   },

   {
      "ray-x/lsp_signature.nvim",
      after = "nvim-lspconfig",
      config = override_req("signature", "plugins.configs.others", "signature"),
   },

   {
      "andymass/vim-matchup",
      opt = true,
      setup = function()
         require("core.utils").packer_lazy_load "vim-matchup"
      end,
   },

   -- load luasnips + cmp related in insert mode only

   {
      "rafamadriz/friendly-snippets",
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },

   {
      "hrsh7th/nvim-cmp",
      after = "friendly-snippets",
      config = override_req("nvim_cmp", "plugins.configs.cmp", "setup"),
   },

   {
      "L3MON4D3/LuaSnip",
      wants = "friendly-snippets",
      after = "nvim-cmp",
      config = override_req("luasnip", "plugins.configs.others", "luasnip"),
   },

   {
      "saadparwaiz1/cmp_luasnip",
      after = "LuaSnip",
   },

   {
      "hrsh7th/cmp-nvim-lua",
      after = "cmp_luasnip",
   },

   {
      "hrsh7th/cmp-nvim-lsp",
      after = "cmp-nvim-lua",
   },

   {
      "hrsh7th/cmp-buffer",
      after = "cmp-nvim-lsp",
   },

   {
      "hrsh7th/cmp-path",
      after = "cmp-buffer",
   },

   -- misc plugins
   {
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = override_req("nvim_autopairs", "plugins.configs.others", "autopairs"),
   },

   {
      "goolord/alpha-nvim",
      config = override_req("alpha", "plugins.configs.alpha"),
   },

   {
      "numToStr/Comment.nvim",
      module = "Comment",
      keys = { "gcc" },
      config = override_req("nvim_comment", "plugins.configs.comment"),
      -- setup = function()
      --    require("core.mappings").comment()
      -- end,
   },

   {
      "is0n/fm-nvim",
      keys = { "<C-a>" },
      config = override_req("fm-nvim", "plugins.configs.fm-nvim"),
      -- setup = function()
      --    require("core.mappings").fm()
      -- end,
   },

   {
      "yashlala/vim-sayonara",
      keys = { "gs", "gS" },
      config = function()
        require('plugins.configs.sayonara')
      end,
      -- setup = function()
      --   require("core.mappings").sayonara()
      -- end,
   },

   {
      "vimwiki/vimwiki",
      cmd = { "VimwikiIndex", "VimwikiMakeDiaryNote" },
      keys = { "<leader>ww", "<leader>w<leader>w"},
      setup = function()
        require('plugins.configs.vimwiki')
      end,
   },

   -- file managing , picker etc
   {
      "kyazdani42/nvim-tree.lua",
      -- only set "after" if lazy load is disabled and vice versa for "cmd"
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      config = override_req("nvim_tree", "plugins.configs.nvimtree", "setup"),
      setup = function()
         require("core.mappings").nvimtree()
      end,
   },

   {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      config = override_req("telescope", "plugins.configs.telescope", "setup"),
      setup = function()
         require("core.mappings").telescope()
      end,
   },
}

--label plugins for operational assistance
plugins = require("core.utils").label_plugins(plugins)

return packer.startup(function(use)
   for _, v in pairs(plugins) do
      use(v)
   end
end)
