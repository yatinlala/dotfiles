-- IMPORTANT NOTE : This is default config, so dont change anything here.
-- use custom/chadrc.lua instead

local M = {}

---- UI -----

M.ui = {
   hl_override = "", -- path of your file that contains highlights
   theme = "gruvbox", -- default theme

   -- Change terminal bg to nvim theme's bg color so it'll match well
   -- For Ex : if you have onedark set in nvchad, set onedark's bg color on your terminal
   transparency = false,
}

---- PLUGIN OPTIONS ----

M.plugins = {
   options = {
      packer = {
         init_file = "plugins.packerInit",
      },
      lspconfig = {
         setup_lspconf = "", -- path of file containing setups of different lsps
      },
      statusline = {
         -- hide, show on specific filetypes
         hidden = {
            "help",
            "NvimTree",
            "terminal",
            "alpha",
         },
         shown = {},

         -- truncate statusline on small screens
         shortline = true,
         style = "default", -- default, round , slant , block , arrow
      },
      esc_insertmode_timeout = 300,
   },
   default_plugin_config_replace = {},
   default_plugin_remove = {},
   install = nil,
}

return M
