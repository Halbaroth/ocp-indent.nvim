local MODREV, SPECREV = 'scm', '-1'
rockspec_format = '3.0'
package = 'ocp-indent.nvim'
version = MODREV .. SPECREV

source = {
  url = 'https://github.com/Halbaroth/ocp-indent.nvim'
}

description = {
  summary = 'ocp-indent integration in Neovim',
  homepage = 'https://github.com/Halbaroth/ocp-indent.nvim',
  license = 'GPL-3.0-or-later',
  labels = { 'neovim', 'plugin' }
}

dependencies = {
  'lua == 5.4',
}

build = {
  type = "builtin",
  modules = {}
}
