local status_ok, impatient = pcall(require, "impatient")
if not status_ok then
  return
end

impatient.enable_profile()

require 'nitay.alpha'
require 'nitay.options'
require 'nitay.plugins'
require 'nitay.keymaps'
require 'nitay.colorscheme'
require 'nitay.statusline'
require 'nitay.bufferline'
require 'nitay.whichkey'
require 'nitay.commentary'
require 'nitay.lsp'
require 'nitay.cmp'
require 'nitay.treesitter'
require 'nitay.toggleterm'
