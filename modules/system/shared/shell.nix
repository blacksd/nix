{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Set zsh as default shell for the user
  # Platform-specific handling:
  # - Darwin: users.users.${username}.shell
  # - NixOS: users.users.${username}.shell (same, but user must exist)
  # Use mkOverride to set higher priority than NixOS default (bash)
  users.users.${username}.shell = lib.mkOverride 900 pkgs.zsh;
}
