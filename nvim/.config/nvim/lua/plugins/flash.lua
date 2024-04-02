-- Jump plugin
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      search = {
        enabled = false,
      },
    },
    char = {
      enabled = false,
    },
    -- options for the floating window that shows the prompt,
    -- for regular jumps
    prompt = {
      enabled = false,
    },
    -- options for remote operator pending mode
    remote_op = {
      -- restore window views and cursor position
      -- after doing a remote operation
      restore = false,
      -- For `jump.pos = "range"`, this setting is ignored.
      -- `true`: always enter a new motion when doing a remote operation
      -- `false`: use the window's cursor position and jump target
      -- `nil`: act as `true` for remote windows, `false` for the current window
      motion = false,
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
