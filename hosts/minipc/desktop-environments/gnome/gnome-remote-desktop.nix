{
  # GNOME Remote Desktop (RDP)
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure GNOME Remote Desktop starts automatically
  systemd.user.services.gnome-remote-desktop = {
    wantedBy = ["graphical-session.target"];
  };

  # Disable auto-login to prevent RDP session conflicts
  services.displayManager.autoLogin.enable = false;

  # Prevent system from suspending (important for remote access)
  systemd.targets = {
    # sleep.enable = false;
    # suspend.enable = false;
    # hibernate.enable = false;
    # hybrid-sleep.enable = false;
  };

  networking.firewall.allowedTCPPorts = [
    3389 # RDP (GNOME Remote Desktop)
  ];
}
