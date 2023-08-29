return {
  'numToStr/Comment.nvim',
  keys = { 'gc', 'gb', 'gcc', 'gbc', 'v', 'V' },
  config = function()
    local comment_ft = require('Comment.ft')

    comment_ft.set('lua', { '--%s', '--[[%s]]' })

    require('Comment').setup({
      ignore = nil,

      -- LHS of operator-pending mapping in NORMAL + VISUAL mode
      opleader = {
        -- line-comment keymap
        line = 'gc',
        -- block-comment keymap
        block = 'gb',
      },

      -- Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
      mappings = {
        -- operator-pending mapping
        -- Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
        basic = true,

        -- extra mapping
        -- Includes `gco`, `gcO`, `gcA`
        extra = true,

        -- extended mapping
        -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
      },

      -- LHS of toggle mapping in NORMAL + VISUAL mode
      -- @type table
      toggler = {
        -- line-comment keymap
        line = 'gcc',

        -- block-comment keymap
        block = 'gbc',
      },
    })
  end,
}
