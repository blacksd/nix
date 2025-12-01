{pkgs, ...}: {
  # NixOS-specific wezterm configuration
  programs.wezterm.extraConfig = ''
    -- NixOS-specific: Enable window decorations
    config.window_decorations = "RESIZE"
  '';
}
