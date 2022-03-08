local present, ts_config = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

local default = {
   ensure_installed = "maintained",
   highlight = {
     enable = true, -- false will disable the whole extension
     uselanguagetree = true,
     disable = { "" }, -- list of language that will be disabled
     additional_vim_regex_highlighting = true,
   },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  --[[ rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
  } ]]
}

local M = {}
M.setup = function(override_flag)
   if override_flag then
      default = require("core.utils").tbl_override_req("nvim_treesitter", default)
   end
   ts_config.setup(default)
end

return M
