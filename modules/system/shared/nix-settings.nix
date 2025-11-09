{
  config,
  lib,
  pkgs,
  ...
}: {
  # Shared Nix configuration for both Darwin and NixOS

  nix.settings = {
    # Enable flakes and new nix command
    experimental-features = ["nix-command" "flakes"];

    # Optimize storage (can be overridden by platform-specific modules)
    auto-optimise-store = lib.mkDefault true;

    # Trusted users
    trusted-users = ["root" "@wheel"];

    # Substituters
    substituters = [
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Channels (if needed)
  # nix.channel.enable = true;
}
