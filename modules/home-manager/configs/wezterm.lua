local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14

config.window_background_opacity = 0.95
config.color_scheme = "Dracula"

config.hide_tab_bar_if_only_one_tab = true

return config