{
  config,
  pkgs,
  lib,
  username,
  useremail,
  ...
}: {
  # User configuration

  # Define your user account
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel" # Enable sudo
      "networkmanager"
      "video"
      "audio"
    ];

    # SSH authorized keys
    # Add your public SSH key here
    openssh.authorizedKeys.keys = [
      # Example: "ssh-ed25519 AAAAC3... user@host"
      # You should add your actual SSH public key here
    ];

    # Set default shell
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Allow sudo without password for wheel group (optional, remove for production)
  security.sudo.wheelNeedsPassword = false;

  # Or require password (recommended for production)
  # security.sudo.wheelNeedsPassword = true;
}
