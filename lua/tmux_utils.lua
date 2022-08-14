local M = {}

-- TODO:
-- only compute this once, or something
local function get_tmux_man()
  local lines = {}
  for line in io.popen("man tmux | col -b"):lines() do
    lines[#lines + 1] = line
  end
  return lines
end

-- TODO:
-- set return cursor point
-- set window line numberings?
-- don't remove formatting
-- how to provide user-configs, default configs
-- have separate lsp-hover-like option
-- add term -> manpage term translator table
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

function M.show_man_floatwin()
  local search_term = vim.call("expand", "<cWORD>")
  make_floatwin(search_term)
end

function make_chunk_arrays(result, hl_group)
  local r = {}
  for i, v in ipairs(result) do
    r[i] = { v .. "\n", hl_group }
  end
  return r
end

-- execute line as tmux command
-- TODO
-- capture and print error output
local function exec_tmux_cmd(line)
  local Job = require("plenary.job")

  local result
  local return_value

  Job:new({
    command = "tmux",
    args = line,
    on_exit = function(j, return_val)
      result = j:result()
      return_value = return_val
    end,
  }):sync()

  local arrayed_chunks
  if return_value == 0 then
    arrayed_chunks = make_chunk_arrays(result)
  else
    arrayed_chunks = make_chunk_arrays({ "command failed: " .. table.concat(line, " ") }, "Error")
  end
  vim.api.nvim_echo(arrayed_chunks, false, {})
  return return_value
end

-- This is copied ~verbatim from... somewhere on Reddit or Stackoverflow.
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

-- TODO
-- more thorough testing, incl. with keymaps
function M.tmux_exec_current_lines()
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

-- keyword/highlight group based jump (????)

-- testing



local test = [[
resize-pane -R 1
resize-pane -L 2
list-clients
list-commands
reskize-pane -R 1
]]

return M
