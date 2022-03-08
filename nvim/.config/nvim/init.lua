local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  return
end

impatient.enable_profile()

require 'nitay.options'
require 'nitay.colorscheme'
require 'nitay.plugins'
require 'nitay.bufferline'
require 'nitay.keymaps'
require 'nitay.alpha'
require 'nitay.gitsigns'
require 'nitay.vimwiki'
