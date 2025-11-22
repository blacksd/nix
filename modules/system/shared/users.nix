{
  config,
  lib,
  pkgs,
  username,
  useremail,
  ...
}: {
  # Shared user configuration
  # This module provides common user settings that work across Darwin and NixOS

  # Note: The actual user creation is handled differently:
  # - On Darwin: users.users.${username} in modules/base/host-users.nix
  # - On NixOS: users.users.${username} with isNormalUser in hosts/rpi4/users.nix

  # Common packages that every user should have
  # (You can add to this list as needed)
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];
}
