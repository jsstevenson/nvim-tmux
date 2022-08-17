if 1 ~= vim.fn.has("nvim-0.7.0") then
  vim.api.nvim_err_writeln("nvim-tmux requires at least nvim-0.7.0.")
  return
end

if vim.g.loaded_nvim_tmux == 1 then
  return
end
vim.g.loaded_nvim_tmux = 1

local nvim_tmux = require("nvim_tmux")

vim.keymap.set("n", "<Plug>(tmux_show_man_floatwin)", function()
  nvim_tmux.show_man_floatwin()
end, {})

vim.keymap.set("n", "<Plug>(tmux_source_file)", function()
  nvim_tmux.source_file()
end, { desc = "Tmux source file in current buffer" })

vim.keymap.set("n", "<Plug>(tmux_execute_cursorline)", function()
  nvim_tmux.execute_cursorline()
end, { desc = "Tmux execute cursorline" })

vim.keymap.set("v", "<Plug>(tmux_execute_selection)", function()
  nvim_tmux.execute_selection()
end, { desc = "Tmux execute selected line(s)" })
