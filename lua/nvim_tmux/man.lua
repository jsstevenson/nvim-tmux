local Man = {}

-- capture term -> search pattern mappings
local option_mappings = {}
option_mappings["exit-empty"] = "exit%-empty %[on"
option_mappings["message-limit"] = "message%-limit num"
option_mappings["base-index"] = "base%-index ind"
option_mappings["default-command"] = "default%-command shell"
option_mappings["default-shell"] = "default%-shell path"
option_mappings["default-size"] = "default%-size XxY"
option_mappings["display-panes-active-colour"] = "display%-panes%-active%-colour colour"
option_mappings["display-panes-colour"] = "display%-panes%-colour colour"
option_mappings["display-panes-time"] = "display%-panes%-time time"
option_mappings["history-limit"] = "history%-limit lines"
option_mappings["key-table"] = "key%-table key"
option_mappings["mouse"] = "mouse %[on"
option_mappings["prefix"] = "prefix key$"
option_mappings["repeat-time"] = "repeat%-time time"
option_mappings["status"] = "status %[off"
option_mappings["status-left"] = "status%-left string"
option_mappings["status-style status%-style"] = "status%-style status%-style style"
option_mappings["visual-activity"] = "visual%-activity %[on"
option_mappings["word-separators"] = "word%-separators string"
option_mappings["main-pane-height"] = "main%-pane%-height h"
option_mappings["main-pane-width"] = "main%-pane%-width w"
option_mappings["mode-keys"] = "mode%-keys %[vi"
option_mappings["mode-style"] = "mode%-style st"
option_mappings["monitor-activity"] = "monitor%-activity %[on"
option_mappings["monitor-bell"] = "monitor%-bell %[on"
option_mappings["monitor-silence"] = "monitor%-silence %[int"
option_mappings["window-status-format"] = "window%-status%-format st"
option_mappings["window-size"] = "window%-size larg"
option_mappings["remain-on-exit"] = "remain%-on%-exit %[on"
option_mappings["window-style"] = "window%-style style"

local alias_mappings = {}
alias_mappings["attach"] = "attach%-session"
alias_mappings["bind"] = "bind%-key %["
alias_mappings["bind-key"] = "bind%-key %["
alias_mappings["breakp"] = "break%-pane"
alias_mappings["capturep"] = "capture%-pane"
alias_mappings["clearhist"] = "clear%-history"
alias_mappings["clearphist"] = "clear%-prompt%-history"
alias_mappings["confirm"] = "confirm%-before %[%-b"
alias_mappings["copyb"] = "copy%-buffer"
alias_mappings["deleteb"] = "delete%-buffer"
alias_mappings["detach"] = "detach%-client"
alias_mappings["display"] = "display%-message %[%-"
alias_mappings["displayp"] = "display%-panes"
alias_mappings["findw"] = "find%-window"
alias_mappings["has"] = "has%-session"
alias_mappings["if"] = "if%-shell %[%-bF"
alias_mappings["joinp"] = "join%-pane"
alias_mappings["killp"] = "kill%-pane"
alias_mappings["killw"] = "kill%-window"
alias_mappings["last"] = "last%-window"
alias_mappings["lastp"] = "last%-pane"
alias_mappings["linkw"] = "link%-window"
alias_mappings["loadb"] = "load%-buffer"
alias_mappings["lock"] = "lock%-server$"
alias_mappings["lockc"] = "lock%-client"
alias_mappings["locks"] = "lock%-session"
alias_mappings["ls"] = "list%-sessions"
alias_mappings["lsb"] = "list%-buffers"
alias_mappings["lsc"] = "list%-clients"
alias_mappings["lscm"] = "list%-commands"
alias_mappings["lsk"] = "list%-keys"
alias_mappings["lsp"] = "list%-panes"
alias_mappings["lsw"] = "list%-windows %["
alias_mappings["list%-windows"] = "list%-windows %["
alias_mappings["menu"] = "display%-menu"
alias_mappings["movep"] = "move%-pane"
alias_mappings["movew"] = "move%-window"
alias_mappings["new"] = "new%-session"
alias_mappings["neww"] = "new%-window"
alias_mappings["next"] = "next%-window"
alias_mappings["nextl"] = "next%-layout"
alias_mappings["pasteb"] = "paste%-buffer"
alias_mappings["pipep"] = "pipe%-pane"
alias_mappings["popup"] = "display%-popup"
alias_mappings["prev"] = "previous%-window"
alias_mappings["prevl"] = "previous%-layout"
alias_mappings["refresh"] = "refresh%-client"
alias_mappings["rename"] = "rename%-session"
alias_mappings["renamew"] = "rename%-window"
alias_mappings["resizep"] = "resize%-pane"
alias_mappings["resizew"] = "resize%-window"
alias_mappings["respawnp"] = "respawn%-pane"
alias_mappings["respawnw"] = "respawn%-window"
alias_mappings["rotatew"] = "rotate%-window"
alias_mappings["run"] = "run%-shell"
alias_mappings["saveb"] = "save%-buffer"
alias_mappings["selectl"] = "select%-layout %["
alias_mappings["select-layout"] = "select%-layout %["
alias_mappings["selectp"] = "select%-pane"
alias_mappings["selectw"] = "select%-window"
alias_mappings["send"] = "send%-keys"
alias_mappings["set"] = "set%-option %["
alias_mappings["set-option"] = "set%-option %["
alias_mappings["setb"] = "set%-buffer %["
alias_mappings["set-buffer"] = "set%-buffer %["
alias_mappings["setenv"] = "set%-environment %[%-Fhg"
alias_mappings["set-window-option"] = "set%-window%-option %["
alias_mappings["show"] = "show%-options"
alias_mappings["showb"] = "show%-buffer"
alias_mappings["showenv"] = "show%-environment %[%-hgs"
alias_mappings["showmsgs"] = "show%-messages"
alias_mappings["showphist"] = "show%-prompt%-history"
alias_mappings["showw"] = "show%-window%-options %["
alias_mappings["show-window-options"] = "show%-window%-options %["
alias_mappings["source"] = "source%-file"
alias_mappings["splitw"] = "split%-window %["
alias_mappings["split-window"] = "split%-window %["
alias_mappings["start"] = "start%-server"
alias_mappings["suspendc"] = "suspend%-client"
alias_mappings["swapp"] = "swap%-pane"
alias_mappings["swapw"] = "swap%-window"
alias_mappings["switchc"] = "switch%-client %["
alias_mappings["switch-client"] = "switch%-client %["
alias_mappings["unbind"] = "unbind%-key %["
alias_mappings["unbind-key"] = "unbind%-key %["
alias_mappings["unlinkw"] = "unlink%-window"
alias_mappings["wait"] = "wait%-for"

local command_mappings = {}
command_mappings["set-hook"] = "set%-hook %[%-ag"
command_mappings["show-hooks"] = "show%-hooks %[%-gpw"
command_mappings["set-environment"] = "set%-environment %[%-Fhg"
command_mappings["command-prompt"] = "command%-prompt %[%-"
command_mappings["confirm-before"] = "confirm%-before %[%-b"
command_mappings["display-message"] = "display%-message %[%-"
command_mappings["choose-buffer"] = "choose%-buffer %[%-"
command_mappings["delete-buffer"] = "delete%-buffer %[%-"
command_mappings["load-buffer"] = "load%-buffer %[%-"
command_mappings["paste-buffer"] = "paste%-buffer %[%-"
command_mappings["set-buffer"] = "set%-buffer %[%-"
command_mappings["clock-mode"] = "clock%-mode %[%-t"
command_mappings["if-shell"] = "if%-shell %[%-bF"
command_mappings["lock-server"] = "lock%-server [^c]"
command_mappings["run-shell"] = "run%-shell %[%-b"
command_mappings["copy-mode"] = "copy%-mode %[%-e"
command_mappings["even-horizontal"] = "even%-horizontal$"
command_mappings["even-vertical"] = "even%-vertical$"
command_mappings["main-horizontal"] = "main%-horizontal$"
command_mappings["main-vertical"] = "main%-vertical$"
command_mappings["tiled"] = "tiled$"

local special_patterns = {}
special_patterns["command%-alias%[%d+]"] = "command%-alias%[]"
special_patterns["terminal%-features%[%d+]"] = "terminal%-features%[]"
special_patterns["terminal%-overrides%[%d+]"] = "terminal%-overrides%[]"
special_patterns["user%-keys%[%d+]"] = "user%-keys%[]"
special_patterns["status%-format%[%d+]"] = "status%-format%[]"
special_patterns["update%-environment%[%d+]"] = "update%-environment%[]"
special_patterns["pane%-colours%[%d+]"] = "pane%-colours%[]"

-- Get tmux man page text
function Man.get_tmux_man(self)
  if not self.man_text then
    local lines = {}
    for line in io.popen("man tmux | col -b"):lines() do
      lines[#lines + 1] = line
    end
    self.man_text = lines
  end
  return self.man_text
end

-- Find definition line for given term
function Man.get_man_line_number(term)
  local man_text = Man:get_tmux_man()
  local pattern
  if option_mappings[term] then
    pattern = option_mappings[term]
  elseif alias_mappings[term] then
    pattern = alias_mappings[term]
  elseif command_mappings[term] then
    pattern = command_mappings[term]
  else
    for key, value in pairs(special_patterns) do
      if string.find(term, key) then
        pattern = value
        break
      end
    end
  end
  if not pattern then
    pattern = string.gsub(term, "%-", "%%-")
  end
  for i, line in ipairs(man_text) do
    if string.find(line, pattern) then
      return i
    end
  end
  return nil
end

return Man
