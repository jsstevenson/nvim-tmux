local group = vim.api.nvim_create_augroup("TmuxFilePlugin", { clear = true })
vim.api.nvim_create_autocmd({ "BufNew", "BufEnter", "BufNewFile" }, {
  callback = function()
    vim.bo.compiler = "tmux"
    vim.api.nvim_echo("in tmux")
  end,
  group = group,
})
