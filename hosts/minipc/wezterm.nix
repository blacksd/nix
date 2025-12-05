{pkgs, ...}: {
  # Minipc-specific wezterm configuration
  programs.wezterm.platformConfig = ''
    -- Minipc-specific: Smaller font size for high DPI display
    config.font_size = 11

    -- Disable window decorations for Hyprland (tiling WM)
    config.window_decorations = "NONE"
  '';
}
