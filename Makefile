export PATH := lua_modules/bin:$(PATH)

init: hooks install

hooks:
	git config core.hooksPath .githooks

install:
	luarocks --tree=lua_modules install --only-deps ocp-indent.nvim-dev-1.rockspec

lint:
	luacheck --config .luacheckrc ./lua/**/*.lua
