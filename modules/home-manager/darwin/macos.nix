{nix-plist-manager, ...}: {
  # macOS user-scope settings common to all darwin hosts, via nix-plist-manager.
  # Host-specific settings: hosts/<host>/home-manager/macos.nix
  # Drift against the live Mac: `task plist-drift`
  imports = [nix-plist-manager.homeManagerModules.default];

  programs.nix-plist-manager = {
    enable = true;
    options.applications.systemSettings.desktopAndDock.missionControl.shortcuts = {
      applicationWindows = "⌃↓";
      missionControl = "⌃↑";
      showDesktop = "-";
    };
  };
}
