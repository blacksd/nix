{pkgs, ...}: {
  # NixOS-specific wezterm configuration
  programs.wezterm.platformConfig = ''
    -- NixOS-specific: Enable window decorations
    config.window_decorations = "RESIZE"
  '';
}
