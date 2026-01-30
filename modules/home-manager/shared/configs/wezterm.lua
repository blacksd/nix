local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14
config.harfbuzz_features = { 'liga=0', 'clig=0', 'calt=0' }

config.window_background_opacity = 0.97
config.color_scheme = "Dracula"

config.scrollback_lines = 8096

-- Disable dead keys - workaround for WezTerm bug #3601 where dead keys
-- are swallowed when followed by non-composable characters.
-- Use macOS character picker (Ctrl+Cmd+Space) for accented characters.
config.use_dead_keys = false

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[SRE-\d+]],
  format = 'https://linear.app/hivemq/issue/$0',
})

config.underline_thickness = '5px'

config.hide_tab_bar_if_only_one_tab = true

local act = wezterm.action

config.keys = {
  -- Word navigation - Option+Arrow
  { key = "LeftArrow",  mods = "OPT", action = act { SendString = "\x1bb" } },
  { key = "RightArrow", mods = "OPT", action = act { SendString = "\x1bf" } },

  -- Line navigation - Cmd+Arrow (beginning/end of line)
  { key = 'LeftArrow',  mods = 'CMD', action = act { SendString = "\x01" } },  -- Ctrl-A
  { key = 'RightArrow', mods = 'CMD', action = act { SendString = "\x05" } },  -- Ctrl-E

  -- Pane navigation - Cmd+Opt+Arrow (like iTerm2)
  { key = 'LeftArrow',  mods = 'CMD|OPT', action = act { ActivatePaneDirection = 'Left' } },
  { key = 'RightArrow', mods = 'CMD|OPT', action = act { ActivatePaneDirection = 'Right' } },
  { key = 'UpArrow',    mods = 'CMD|OPT', action = act { ActivatePaneDirection = 'Up' } },
  { key = 'DownArrow',  mods = 'CMD|OPT', action = act { ActivatePaneDirection = 'Down' } },

  -- Tab navigation - Cmd+Shift+Arrow
  { key = 'LeftArrow',  mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },

  -- Split panes - Cmd+D / Cmd+Shift+D
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Delete word backward - Option+Backspace
  { key = 'Backspace', mods = 'OPT', action = act { SendString = "\x17" } },  -- Ctrl-W

  -- Delete to beginning of line - Cmd+Backspace
  { key = 'Backspace', mods = 'CMD', action = act { SendString = "\x15" } },  -- Ctrl-U

  -- Delete word forward - Option+Delete
  { key = 'Delete', mods = 'OPT', action = act { SendString = "\x1bd" } },

  -- Shift+Enter sends literal newline (useful for multi-line input)
  { key = 'Enter', mods = 'SHIFT', action = act { SendString = "\n" } },

  -- Toggle pane zoom (maximize/restore current pane) - Cmd+Shift+Enter (like iTerm2)
  { key = 'Enter', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
}

return config
