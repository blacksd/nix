local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14

config.window_background_opacity = 0.95
config.color_scheme = "Dracula"

config.hide_tab_bar_if_only_one_tab = true

local act = wezterm.action

config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key="LeftArrow", mods="OPT", action=act{ SendString="\x1bb" } };
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key="RightArrow", mods="OPT", action=act{ SendString="\x1bf" } };
}

return config