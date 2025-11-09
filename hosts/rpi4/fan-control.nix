{
  config,
  lib,
  pkgs,
  ...
}: {
  # Raspberry Pi 4 Fan Control
  #
  # For now, fan control must be configured manually in /boot/config.txt
  # Add this line:
  #   dtoverlay=gpio-fan,gpiopin=14,temp=55000
  #
  # Then reboot for changes to take effect.

  # Systemd service approach commented out for now
  # systemd.services.rpi-fan-config = {
  #   description = "Configure Raspberry Pi fan control in config.txt";
  #   wantedBy = ["multi-user.target"];
  #   after = ["local-fs.target"];
  #
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  #
  #   script = ''
  #     CONFIG_FILE="/boot/config.txt"
  #     FAN_OVERLAY="dtoverlay=gpio-fan,gpiopin=14,temp=55000"
  #
  #     if [ ! -f "$CONFIG_FILE" ]; then
  #       echo "Warning: $CONFIG_FILE not found, skipping fan configuration"
  #       exit 0
  #     fi
  #
  #     if grep -q "dtoverlay=gpio-fan" "$CONFIG_FILE"; then
  #       echo "Fan overlay already configured in $CONFIG_FILE"
  #       exit 0
  #     fi
  #
  #     echo "" >> "$CONFIG_FILE"
  #     echo "# Fan control - added by NixOS" >> "$CONFIG_FILE"
  #     echo "$FAN_OVERLAY" >> "$CONFIG_FILE"
  #     echo "Fan control configured in $CONFIG_FILE - reboot required for changes to take effect"
  #   '';
  # };

  # Install monitoring tools
  environment.systemPackages = with pkgs; [
    lm_sensors  # For temperature monitoring
  ];
}
