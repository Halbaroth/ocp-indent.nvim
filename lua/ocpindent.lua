local api = vim.api
local job = require('plenary.job')

local M = {
  default_opts = {
    on_save = true,
    bindings = true,
    integrations = {
      which_key = false,
    },
  },
}

M.opts = M.default_opts

local function run(start, end_, on_exit)
  job:new({
    command = 'ocp-indent',
    args = { '--lines', start .. '-' .. end_ },
    writer = vim.fn.getline('1', '$'),
    on_exit = function(j, return_val)
      print(return_val)
      on_exit (j:result())
    end,
  }):sync()
end

local function update_buffer(start, end_, res)
  api.nvim_buf_set_option(0, 'modifiable', true)
  local lines = api.nvim_buf_get_lines(0, start-1, end_, true)
  local changed = false
  for i, _ in ipairs(lines) do
    if not (lines[i] == res[i]) then
      changed = true
    end
    lines[i] = res[start-1+i]
  end
  if changed then
    api.nvim_buf_set_lines(0, start-1, end_, true, lines)
  end
  api.nvim_buf_set_option(0, 'modifiable', false)
end

local function indent_visual_block()
  local u = vim.fn.line('v')
  local v = vim.fn.line('.')
  local start = math.min(u, v)
  local end_ = math.max(u, v)
  run (start, end_, function(res) update_buffer(start, end_, res) end)
end

function M.callback()
  if M.opts.integrations.which_key then
    local wk = require('whick-key')
    wk.register({
      o = {
        name = 'ocp-indent',
        i = { M.indent_visual_block, 'ocp-indent' },
      },
    },
    { mode = 'v', prefix = '<localleader>', buffer = 0 })
  else
    vim.keymap.set('v', '<localleader>oi', M.indent_visual_block)
  end
end

function M.set_bindings()
  api.nvim_create_augroup('ocp-indent', {})

  vim.api.nvim_create_autocmd(
    'FileType',
    {
      group = 'ocp-indent',
      pattern = { 'ocaml' },
      callback = M.callback
    })
end

function M.setup(user_opts)
	M.opts = vim.tbl_deep_extend("keep", user_opts or {}, M.default_opts)

  if vim.fn.executable('ocp-indent') == 0 then
    print('ocp-indent: ocp-indent not in path. Aborting setup')
    return
  end

  if M.opts.bindings then
    M.set_bindings()
  end
end

return M
