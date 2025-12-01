{pkgs, ...}: {
  # XRDP - Alternative RDP server (simpler than GNOME Remote Desktop)
  services.xrdp = {
    enable = true;
    defaultWindowManager = "gnome-session";
    openFirewall = true;
  };

  # Disable auto-login to prevent RDP session conflicts
  services.displayManager.autoLogin.enable = false;

  # systemd.targets = {
  #   sleep.enable = false;
  #   suspend.enable = false;
  #   hibernate.enable = false;
  #   hybrid-sleep.enable = false;
  # };

  # TODO: test this

  # # Configure systemd-logind to allow sleep normally
  # services.logind = {
  #   lidSwitch = "suspend";
  #   lidSwitchDocked = "ignore";
  #   lidSwitchExternalPower = "suspend";
  #   extraConfig = ''
  #     HandlePowerKey=suspend
  #     IdleAction=suspend
  #     IdleActionSec=30min
  #   '';
  # };

  # # Create a systemd service to inhibit sleep when XRDP sessions are active
  # systemd.services.xrdp-sleep-inhibitor = {
  #   description = "Inhibit sleep when XRDP sessions are active";
  #   after = ["xrdp.service"];
  #   wants = ["xrdp.service"];

  #   script = ''
  #     INHIBIT_PID=""

  #     while true; do
  #       # Check if there are active XRDP sessions by looking at xrdp-sesman connections
  #       ACTIVE_SESSIONS=$(${pkgs.nettools}/bin/netstat -tn | grep ':3350' | grep ESTABLISHED | wc -l)

  #       if [ "$ACTIVE_SESSIONS" -gt 0 ]; then
  #         # Active sessions exist - ensure inhibitor is running
  #         if [ -z "$INHIBIT_PID" ] || ! kill -0 "$INHIBIT_PID" 2>/dev/null; then
  #           ${pkgs.systemd}/bin/systemd-inhibit \
  #             --what=sleep:idle \
  #             --who=xrdp \
  #             --why="Active RDP session(s)" \
  #             --mode=block \
  #             sleep infinity &
  #           INHIBIT_PID=$!
  #           echo "XRDP session active - sleep inhibited (PID: $INHIBIT_PID)"
  #         fi
  #       else
  #         # No active sessions - stop inhibitor if running
  #         if [ -n "$INHIBIT_PID" ] && kill -0 "$INHIBIT_PID" 2>/dev/null; then
  #           kill "$INHIBIT_PID"
  #           INHIBIT_PID=""
  #           echo "No XRDP sessions - sleep inhibitor removed"
  #         fi
  #       fi

  #       sleep 30
  #     done
  #   '';

  #   serviceConfig = {
  #     Type = "simple";
  #     Restart = "always";
  #     RestartSec = "10s";
  #   };

  #   wantedBy = ["multi-user.target"];
  # };
}
