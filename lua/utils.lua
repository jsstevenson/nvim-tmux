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
function show_man_floatwin(term)
  -- setup options
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
end

-- execute line as tmux command
function show_man_popup(term)

end

-- testing
--
-- return M
