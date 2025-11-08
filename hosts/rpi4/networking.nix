{
  config,
  lib,
  pkgs,
  ...
}: {
  # Network configuration for Raspberry Pi 4

  # Enable networking
  networking.networkmanager.enable = false;

  # Use systemd-networkd instead (more lightweight)
  systemd.network.enable = true;

  # Ethernet configuration - DHCP by default
  systemd.network.networks."10-ethernet" = {
    matchConfig.Name = "eth0";
    networkConfig.DHCP = "yes";
    dhcpV4Config.RouteMetric = 100;
  };

  # WiFi configuration - DHCP
  # Uncomment and configure if you want to use WiFi
  # systemd.network.networks."20-wireless" = {
  #   matchConfig.Name = "wlan0";
  #   networkConfig.DHCP = "yes";
  #   dhcpV4Config.RouteMetric = 200;
  # };

  # Wireless configuration (if needed)
  # networking.wireless = {
  #   enable = true;
  #   networks = {
  #     "YourSSID" = {
  #       psk = "YourPassword";
  #     };
  #   };
  # };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22]; # SSH
    allowedUDPPorts = [];
  };

  # Enable avahi for .local domain resolution
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Static IP configuration example (commented out)
  # systemd.network.networks."10-ethernet" = {
  #   matchConfig.Name = "eth0";
  #   networkConfig = {
  #     Address = "192.168.1.100/24";
  #     Gateway = "192.168.1.1";
  #     DNS = ["8.8.8.8" "8.8.4.4"];
  #   };
  # };
}
