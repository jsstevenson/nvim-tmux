# nvim-tmux

Neovim plugin for editing Tmux configuration and scripting files. Consists largely of features provided in [vim-tmux](https://github.com/tmux-plugins/vim-tmux), rewritten in Lua for easier Neovim integration and extensibility moving forward.

## Features

* Improved file detection
* Support for `:make`, calling `tmux source` on the file in the current buffer. A Lua function to do the same with the [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) Job API is included as well.
* Execute command under cursorline or visual select
* Show the man page entry for the item under the cursor in a floating window

## Requirements

* Neovim 0.7.0+
* Tmux (tested on 3.3a)
* [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

With [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
    use({
      "jsstevenson/nvim-tmux",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("nvim_tmux").setup()
      end,
    })
```

## Configuration

Provide a table overwriting any of the following keys to `setup()` -- defaults are below:

```lua
local nvim_tmux_default_configs = {
  floatwin = {
    -- Height and width of tmux man page display in floating window. Should be
    -- values between 0 and 1, reflecting the % of the buffer height/width to use
    height = 0.85,
    width = 0.85,

    -- Styling of man page floating window. Set to `nil` to enable line number,
    -- color columns, etc (see `style` under :h nvim_open_win)
    style = "minimal",

    -- Styling of man page floating window border. See `border` under
    -- :h nvim_open_win for the complete list of options.
    border = "single"
  }
}
```

No keymaps are provided by default, but you can put the following into an `augroup` or `ftplugin/tmux.lua`:

```lua
vim.keymap.set("n", "<leader>s", "<Plug>(tmux_source_file)", { silent = true, remap = false })
vim.keymap.set("n", "K", "<Plug>(tmux_show_man_floatwin)", { silent = true, remap = false })
vim.keymap.set("n", "g!!", "<Plug>(tmux_execute_cursorline)", { silent = true, remap = false })
vim.keymap.set("v", "g!", "<Plug>(tmux_execute_selection)", { silent = true, remap = false })
```
