local group = vim.api.nvim_create_augroup("SetTmuxFiletype", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  group = group,
  pattern = "*.tmux",
  callback = function()
    vim.bo.filetype = "tmux"
  end,
})
