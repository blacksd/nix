local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14
config.harfbuzz_features = { 'liga=0', 'clig=0', 'calt=0' }

config.window_background_opacity = 0.95
config.color_scheme = "Dracula"

config.hide_tab_bar_if_only_one_tab = true

local act = wezterm.action

config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word and Option-Right equivalent to Alt-f for forward-word
  { key = "LeftArrow",  mods = "OPT", action = act { SendString = "\x1bb" } },
  { key = "RightArrow", mods = "OPT", action = act { SendString = "\x1bf" } },
  -- Beginning and end of the line
  { key = 'LeftArrow',  mods = 'CMD', action = act { SendString = "\x1bOH" }, },
  { key = 'RightArrow', mods = 'CMD', action = act { SendString = "\x1bOF" }, },
  -- Select next tab with cmd-opt-left/right arrow
  {
    key = 'LeftArrow',
    mods = 'CMD|OPT',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'RightArrow',
    mods = 'CMD|OPT',
    action = act.ActivateTabRelative(1)
  },
  -- Select next pane with cmd-arrow
  { key = 'LeftArrow',  mods = 'CMD',       action = act { ActivatePaneDirection = 'Left' }, },
  { key = 'RightArrow', mods = 'CMD',       action = act { ActivatePaneDirection = 'Right' }, },
  { key = 'UpArrow',    mods = 'CMD',       action = act { ActivatePaneDirection = 'Up' }, },
  { key = 'DownArrow',  mods = 'CMD',       action = act { ActivatePaneDirection = 'Down' }, },
  -- Split
  { key = 'd',          mods = 'CMD',       action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
  { key = 'd',          mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
}

return config