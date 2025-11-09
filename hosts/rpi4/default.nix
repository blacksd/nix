{
  config,
  pkgs,
  lib,
  modulesPath,
  username,
  hostname,
  ...
}: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    # Note: disko-config.nix commented out to avoid conflict with sd-image
    # Uncomment if deploying to existing system without building SD image
    # ./disko-config.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./users.nix
    ../../modules/shared/nix-settings.nix
  ];

  # NixOS release version
  system.stateVersion = "25.05";

  # Set hostname
  networking.hostName = hostname;

  # Timezone
  time.timeZone = "Europe/Rome";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
    tmux
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Auto-upgrade
  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };

  # Disable ZFS to avoid kernel rebuilds
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];

  # SD card longevity optimizations
  boot.tmp.useTmpfs = true; # Use tmpfs for /tmp (RAM instead of SD writes)

  # Reduce logging to minimize SD card writes
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxRetentionSec=7day
  '';

  # Optional: Move /var/log to tmpfs (loses logs on reboot)
  # Uncomment if you want to minimize writes further
  # boot.tmp.tmpfsSize = "25%"; # Adjust size as needed
  # fileSystems."/var/log" = {
  #   fsType = "tmpfs";
  #   device = "tmpfs";
  #   options = [ "nosuid" "nodev" "noexec" "size=50M" ];
  # };
}
