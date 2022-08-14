local K = vim.keymap.set

K(
  "n",
  "<Plug>(tmux_show_man_floatwin)",
  "<CMD>lua require('tmux_nvim').tmux_show_man_floatwin()<CR>g@",
  { desc = "Show man for term under cursor in floating window" }
)

K(
  "n",
  "<Plug>(tmux_source_file)",
  "<CMD>lua require('tmux_nvim').tmux_source_file()<CR>g@",
  { desc = "Tmux source file in current buffer" }
)

K(
  "n",
  "<Plug>(tmux_execute_selection)",
  "<ESC><CMD>lua require('tmux_nvim').tmux_execute_selection()<CR>",
  { desc = "Tmux execute currently selected command(s)" }
)
