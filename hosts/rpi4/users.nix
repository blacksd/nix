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
      # "video"
      # "audio"
    ];

    # SSH authorized keys
    # Add your public SSH key here
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL0m7Rvr/ReyLZZdMKU78oj3v7fGHRBriWDenQFFqbH5ziRWt0HubQMIzp6HS1848ATo5F6lu/BrFHWoMxTyJd4= marco@simpleton"
      # Example: "ssh-ed25519 AAAAC3... user@host"
      # You should add your actual SSH public key here
    ];

    # Default shell (zsh) is set in shared modules
  };

  # Allow sudo without password for wheel group (optional, remove for production)
  security.sudo.wheelNeedsPassword = false;

  # Or require password (recommended for production)
  # security.sudo.wheelNeedsPassword = true;
}
