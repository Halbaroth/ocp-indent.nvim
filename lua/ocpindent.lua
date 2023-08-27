local api = vim.api

local M = {
  default_opts = {
    on_save = false,
    bindings = false,
  },
}

M.opts = M.default_opts

local function error(msg)
  vim.notify(msg, vim.log.levels.ERROR, {title = 'ocp-indent'})
end

local function run(start, end_, on_exit)
  local cmdline =
    'ocp-indent --lines ' .. start .. '-' .. end_
  local res = vim.fn.systemlist(cmdline, vim.fn.getline('1', '$'))
  on_exit(res)
end

local function update_buffer(start, end_, res)
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
end

function M.indent_visual_block()
  local u = vim.fn.line('v')
  local v = vim.fn.line('.')
  local start = math.min(u, v)
  local end_ = math.max(u, v)
  run (start, end_, function(res) update_buffer(start, end_, res) end)
end

function M.indent_buffer()
  if vim.bo.filetype == 'ocaml' then
    local end_ = vim.fn.line('$')
    run (1, end_, function(res) update_buffer(1, end_, res) end)
  end
end

local function callback_bindings()
  local loaded, wk = pcall(require, 'which-key')
  if loaded then
    wk.register({
      o = {
        name = 'ocp-indent',
        i = { M.indent_visual_block, 'reindent selection' },
      },
    },
    { mode = 'v', prefix = '<localleader>', buffer = 0 })
  else
    vim.keymap.set('v', '<localleader>oi', M.indent_visual_block)
  end
end

function M.setup(user_opts)
	M.opts = vim.tbl_deep_extend("keep", user_opts or {}, M.default_opts)

  if vim.fn.executable('ocp-indent') == 0 then
    error('ocp-indent not in path. Aborting setup.')
    return
  end

  api.nvim_create_augroup('ocp-indent', {})

  if M.opts.bindings then
    vim.api.nvim_create_autocmd(
      'FileType',
      {
        group = 'ocp-indent',
        pattern = { 'ocaml' },
        callback = callback_bindings
      })
  end

  if M.opts.on_save then
    vim.api.nvim_create_autocmd(
      'BufWritePre',
      {
        group = 'ocp-indent',
        callback = M.indent_buffer
      })
  end
end

return M
