_G.P = function(v)
  print(vim.inspect(v))
  return v
end

_G.RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

_G.R = function(name)
  RELOAD(name)
  return require(name)
end

local M = {}

function M.toggleBg()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end

function M.setColors()
  vim.cmd 'colorscheme gruvbox'
  vim.cmd [[
        hi def IlluminatedWordText guibg=#504945
        hi def IlluminatedWordRead guibg=#504945
        hi def IlluminatedWordWrite guibg=#504945
        hi MatchWord cterm=underline gui=underline
    ]]
end

local pwconfig = {
  ui = {
    default = 'float',
    float = {
      border = 'rounded',
      float_hl = 'Normal',
      border_hl = 'FloatBorder',
      blend = 0,
      height = 0.8,
      width = 0.8,
      x = 0.5,
      y = 0.5,
    },
    split = {
      direction = 'topleft',
      size = 24,
    },
  },
  edit_cmd = 'edit',
  on_close = {},
  on_open = {},
  cmds = {
    lf_cmd = 'lf',
    lazygit_cmd = 'lazygit',
  },
  mappings = {
    vert_split = '<C-v>',
    horz_split = '<C-h>',
    tabedit = '<C-t>',
    edit = '<C-e>',
    ESC = '<ESC>',
  },
}

local method = pwconfig.edit_cmd
function M.setup(user_options)
  pwconfig = vim.tbl_deep_extend('force', pwconfig, user_options)
end

function M.setMethod(opt)
  method = opt
end

local function checkFile(file)
  if io.open(file, 'r') ~= nil then
    for line in io.lines(file) do
      vim.cmd(method .. ' ' .. vim.fn.fnameescape(line))
    end
    method = pwconfig.edit_cmd
    io.close(io.open(file, 'r'))
    os.remove(file)
  end
end

local function on_exit()
  M.closeCmd()
  for _, func in ipairs(pwconfig.on_close) do
    func()
  end
  checkFile '/tmp/fm-nvim'
  checkFile(vim.fn.getenv 'HOME' .. '/.cache/fff/opened_file')
  vim.cmd [[ checktime ]]
end

local function postCreation(suffix)
  for _, func in ipairs(pwconfig.on_open) do
    func()
  end
  vim.api.nvim_buf_set_option(M.buf, 'filetype', 'Fm')
  vim.api.nvim_buf_set_keymap(
    M.buf,
    't',
    pwconfig.mappings.edit,
    '<C-\\><C-n>:lua require("fm-nvim").setMethod("edit")<CR>i' .. suffix,
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    M.buf,
    't',
    pwconfig.mappings.tabedit,
    '<C-\\><C-n>:lua require("fm-nvim").setMethod("tabedit")<CR>i' .. suffix,
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    M.buf,
    't',
    pwconfig.mappings.horz_split,
    '<C-\\><C-n>:lua require("fm-nvim").setMethod("split | edit")<CR>i' .. suffix,
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    M.buf,
    't',
    pwconfig.mappings.vert_split,
    '<C-\\><C-n>:lua require("fm-nvim").setMethod("vsplit | edit")<CR>i' .. suffix,
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(M.buf, 't', '<ESC>', pwconfig.mappings.ESC, { silent = true })
end

local function createWin(cmd, suffix)
  M.buf = vim.api.nvim_create_buf(false, true)
  local win_height = math.ceil(vim.api.nvim_get_option 'lines' * pwconfig.ui.float.height - 4)
  local win_width = math.ceil(vim.api.nvim_get_option 'columns' * pwconfig.ui.float.width)
  local col = math.ceil((vim.api.nvim_get_option 'columns' - win_width) * pwconfig.ui.float.x)
  local row = math.ceil((vim.api.nvim_get_option 'lines' - win_height) * pwconfig.ui.float.y - 1)
  local opts = {
    style = 'minimal',
    relative = 'editor',
    border = pwconfig.ui.float.border,
    width = win_width,
    height = win_height,
    row = row,
    col = col,
  }
  M.win = vim.api.nvim_open_win(M.buf, true, opts)
  postCreation(suffix)
  vim.fn.termopen(cmd, { on_exit = on_exit })
  vim.api.nvim_command 'startinsert'
  vim.api.nvim_win_set_option(
    M.win,
    'winhl',
    'Normal:' .. pwconfig.ui.float.float_hl .. ',FloatBorder:' .. pwconfig.ui.float.border_hl
  )
  vim.api.nvim_win_set_option(M.win, 'winblend', pwconfig.ui.float.blend)
  M.closeCmd = function()
    vim.api.nvim_win_close(M.win, true)
    vim.api.nvim_buf_delete(M.buf, { force = true })
  end
end

local function createSplit(cmd, suffix)
  vim.cmd(pwconfig.ui.split.direction .. ' ' .. pwconfig.ui.split.size .. 'vnew')
  M.buf = vim.api.nvim_get_current_buf()
  postCreation(suffix)
  vim.fn.termopen(cmd, { on_exit = on_exit })
  vim.api.nvim_command 'startinsert'
  M.closeCmd = function()
    vim.cmd 'bdelete!'
  end
end

function M.Lf(dir)
  dir = dir or '.'
  createWin(pwconfig.cmds.lf_cmd .. ' -selection-path /tmp/fm-nvim ' .. dir, 'l')
end

function M.Lazygit(dir)
  dir = dir or '.'
  createWin(pwconfig.cmds.lazygit_cmd .. ' -w ' .. dir, 'e')
end

return M
