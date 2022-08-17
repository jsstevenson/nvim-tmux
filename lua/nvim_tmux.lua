local M = {}
local Job = require("plenary.job")
local Config = require("nvim_tmux.config")
local Man = require("nvim_tmux.man")

-- initialize user configs
M.setup = function(config)
  local cfg = Config:set(config):get()
  return cfg
end

-- Build floating window scrolled to entry for the given term.
local function make_floatwin(term)
  local ui = vim.api.nvim_list_uis()[1]
  local cfg = Config:get()
  local win_height = math.ceil(ui.height * cfg.floatwin.height)
  local win_width = math.ceil(ui.width * cfg.floatwin.width)
  local win_opts = {
    relative = "editor",
    col = (ui.width / 2) - (win_width / 2),
    row = (ui.height / 2) - (win_height / 2),
    height = win_height,
    width = win_width,
    anchor = "NW",
    border = cfg.floatwin.border,
    noautocmd = true,
    style = cfg.floatwin.style,
  }
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { nowait = true, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", ":close<CR>", { nowait = true, noremap = true, silent = true })

  local man_text = Man.get_tmux_man()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, man_text)
  local cursor_line = Man.get_man_line_number(term)
  if cursor_line == nil then
    print("Unrecognized tmux keyword: " .. term)
    return
  end
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.api.nvim_win_set_cursor(win, { cursor_line, 0 })

  return buf, win
end

-- Open floating window with man page entry for term under cursor.
function M.show_man_floatwin()
  local search_term = vim.call("expand", "<cWORD>")
  make_floatwin(search_term)
end

-- Format command output into chunks to match structure required by nvim_echo()
local function make_result_chunks(result, hl_group)
  local r = {}
  for i, v in ipairs(result) do
    r[i] = { v .. "\n", hl_group }
  end
  return r
end

local function exec_tmux_job(args)
  local result
  local return_value

  Job:new({
    command = "tmux",
    args = args,
    on_exit = function(j, return_val)
      result = j:result()
      return_value = return_val
    end,
  }):sync()
  return { result, return_value }
end

-- Execute line as tmux command
local function exec_tmux_cmd(line)
  local line_args = {}
  for i in line:gmatch("%g+") do
    table.insert(line_args, i)
  end
  local job_result = exec_tmux_job(line_args)

  local result_chunks
  if job_result[2] == 0 then
    result_chunks = make_result_chunks(job_result[1])
  else
    result_chunks = make_result_chunks({ "command failed: " .. line }, "Error")
  end
  vim.api.nvim_echo(result_chunks, false, {})
  return job_result[2]
end

-- Execute tmux command under current cursorline
function M.execute_cursorline()
  local pos = vim.fn.getpos(".")
  local line = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], false)
  exec_tmux_cmd(line[1])
end

-- Retrieve lines contained by visual selection
local function get_visual_selection()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", true)
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  return lines
end

-- Execute tmux command under current visual selection
function M.execute_selection()
  local lines = get_visual_selection()
  for _, line in ipairs(lines) do
    local return_value = exec_tmux_cmd(line)
    if return_value ~= 0 then
      break
    end
  end
end

-- Equivalent to included :make command but using Plenary job routine
function M.source_file()
  local file_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local args = { "source", file_path }
  local _, return_value = exec_tmux_job(args)
  if return_value == 1 then
    vim.api.nvim_echo({ { "Source " .. file_path .. " failed", "Error" } }, false, {})
  end
  return return_value
end

return M
