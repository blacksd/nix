{
  config,
  pkgs,
  lib,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./desktop-environments
    ../../modules/system/nixos
    ../../modules/system/shared
  ];

  # Hostname
  networking.hostName = hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Desktop environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Printing
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [
    22 # SSH
  ];

  # Firefox
  programs.firefox.enable = true;

  # Zsh is enabled in shared modules

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    font-awesome
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ethtool # For managing network interfaces and WoL
  ];

  # NixOS state version
  system.stateVersion = "25.11";
}
