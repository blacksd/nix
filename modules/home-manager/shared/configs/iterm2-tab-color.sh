# iTerm2 tab color management
# Sets tab color from hex value or resets to default

iterm2_set_tab_color() {
  if [ -z "$ITERM_SESSION_ID" ]; then
    return
  fi

  if [ -z "$1" ]; then
    # Reset to default when no color provided
    echo -e "\033]6;1;bg;*;default\a"
    return
  fi

  local hex_color="$1"
  # Remove leading # if present
  hex_color="${hex_color#\#}"

  # Convert hex to RGB
  local r=$((16#${hex_color:0:2}))
  local g=$((16#${hex_color:2:2}))
  local b=$((16#${hex_color:4:2}))

  # Set iTerm2 tab color
  echo -e "\033]6;1;bg;red;brightness;$r\a"
  echo -e "\033]6;1;bg;green;brightness;$g\a"
  echo -e "\033]6;1;bg;blue;brightness;$b\a"
}

# Hook into direnv to set/unset tab color
_iterm2_direnv_hook() {
  if [ -n "$ITERM2_TAB_COLOR" ]; then
    iterm2_set_tab_color "$ITERM2_TAB_COLOR"
  else
    iterm2_set_tab_color  # Reset when no color set
  fi
}

# Add hook using zsh's chpwd (triggered on directory change)
# This works with oh-my-zsh's direnv plugin instead of fighting it
autoload -U add-zsh-hook
add-zsh-hook chpwd _iterm2_direnv_hook

# Also run it now in case we're already in a directory with .envrc
_iterm2_direnv_hook
