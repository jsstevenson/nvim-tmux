vim.bo.makeprg = "tmux source-file " .. vim.fn.expand("%:p")
vim.bo.errorformat = "\\%f:%l:%m, \\%+Gunknown\\ command:\\ %s"
