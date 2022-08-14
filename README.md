# nvim-tmux

Neovim plugin for editing Tmux configuration and scripting files. Consists largely of features provided in [vim-tmux](https://github.com/tmux-plugins/vim-tmux), rewritten in Lua for easier Neovim integration and extensibility moving forward.

## Features

* Improved file detection
* Incorporation of the built-in Neovim compilation tooling -- provides a `compile/` file that sets the `makeprg` and `errorformat` settings used by `:make` to call `tmux source` on the file loaded in the current buffer. A Lua funciton to do the same with the [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) Job API is included as well.
* Key command to execute the highlighted or visually selected line(s)
* Key command to show the man page entry for the item under the cursor in a floating window

## Requirements

* Tmux

## Installation

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
    use({
      "jsstevenson/nvim-tmux",
      config = function()
        require("nvim_tmux").setup({})
      end
    })
```

## Configuration

Provide a table containing any of the following keys to `setup()` -- defaults are below:

```lua
local nvim_tmux_default_configs = {
  -- Height and width of tmux man page display in floating window. Should be
  -- values between 0 and 1, reflecting the % of the buffer height/width to use
  man_floatwin_height = 0.85,
  man_floatwin_width = 0.85,

  -- Styling of man page floating window. Set to `nil` to enable line number,
  -- color columns, etc (see `style` under :h nvim_open_win)
  man_floatwin_style = "minimal",

  -- Styling of man page floating window border. See `border` under
  -- :h nvim_open_win for the complete list of options.
  man_floatwin_border = "single"
}
```
