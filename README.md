# ocp-indent.nvim

![Static Badge](https://img.shields.io/badge/License-GPL_v3-yellow)

Integration plugin for [ocp-indent](https://github.com/OCamlPro/ocp-indent).

## Features

- You can choose tree way to reindent your code:
  + Automatically indent while typing.
  + Reindent selected zone.
  + Reindent on save.
- (TODO) Detect ocp-indent configuration files.

## Installation & Usage

Install using your favorite package manager. For instance using
[Lazy](https://github.com/folke/lazy.nvim)

```lua
{
  'Halbaroth/ocp-indent.nvim',
  config = true
}
```
For custom configuration, use
```lua
{
  'Halbaroth/ocp-indent.nvim',
  opts = { ... },
  config = true
}
```

## Keymaps
By default, the plugin doesn't register any shortcuts. Use the option `bindings`
to set up default shortcuts.

## Advanced usage (API)
(TODO)
