local M = {}
local Job = require("plenary.job")

-- Get tmux man page text.
-- TODO:
-- only compute this once, or something
local function get_tmux_man()
  local lines = {}
  for line in io.popen("man tmux | col -b"):lines() do
    lines[#lines + 1] = line
  end
  return lines
end

-- Build floating window scrolled to entry for the given term.
-- TODO:
-- set return cursor point
-- set window line numberings?
-- don't remove formatting
-- how to provide user-configs, default configs
-- have separate lsp-hover-like option
-- add term -> manpage term translator table
-- use highlight group if keyword is unavailable
local function make_floatwin(term)
  local config_defaults = {
    man_height = 0.85,
    man_width = 0.85,
  }

  local ui = vim.api.nvim_list_uis()[1]
  local win_height = math.ceil(ui.height * config_defaults.man_height)
  local win_width = math.ceil(ui.width * config_defaults.man_width)
  local win_opts = {
    relative = "editor",
    col = (ui.width / 2) - (win_width / 2),
    row = (ui.height / 2) - (win_height / 2),
    height = win_height,
    width = win_width,
    anchor = "NW",
    border = "single",
    noautocmd = true,
    style = "minimal",
  }
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { nowait = true, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", ":close<CR>", { nowait = true, noremap = true, silent = true })

  local man_text = get_tmux_man()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, man_text)
  local cursor_line = nil
  for i, line in ipairs(man_text) do
    if string.find(line, term) then
      cursor_line = i
      break
    end
  end
  if cursor_line == nil then
    print("Unrecognized tmux keyword: " .. term)
    return
  end
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.api.nvim_win_set_cursor(win, { cursor_line, 0 })

  return buf, win
end

-- Open floating window with man page entry for term under cursor.
function M.tmux_show_man_floatwin()
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
-- TODO
-- capture and print error output
local function exec_tmux_cmd(line)
  local result, return_value = exec_tmux_job(line)

  local result_chunks
  if return_value == 0 then
    result_chunks = make_result_chunks(result)
  else
    result_chunks = make_result_chunks({ "command failed: " .. table.concat(line, " ") }, "Error")
  end
  vim.api.nvim_echo(result_chunks, false, {})
  return return_value
end

-- Equivalent to included :make command but using Plenary job routine
-- TODO
-- Get better error printing
function M.source_tmux_conf()
  local args = { "source", vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) }
  local _, return_value = exec_tmux_job(args)
  if return_value == 1 then
    vim.api.nvim_echo({ { "Source .tmux.conf failed", "Error" } }, false, {})
  end
  return return_value
end

-- Retrieve lines contained by visual selection.
-- This is copied ~verbatim from... somewhere on Reddit or Stackoverflow.
-- TODO
-- Retrieve complete lines, rather than that broken up by block or regular visual mode
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table
end

-- Execute tmux command under current cursor/selection
-- TODO
-- more thorough testing, incl. with keymaps
function M.tmux_execute_selection()
  local position = vim.fn.getpos(".")
  local visual_position = vim.fn.getpos("v")
  if position[2] ~= visual_position[2] then
    local lines = get_visual_selection()
    for _, line in ipairs(lines) do
      local return_value = exec_tmux_cmd(line)
      if return_value ~= 0 then
        break
      end
    end
  else
    local line = vim.api.nvim_buf_get_lines(0, position[2] - 1, position[2], false)
    exec_tmux_cmd(line)
  end
end

return M
