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
      "https://blacksd.cachix.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "blacksd.cachix.org-1:Oq+4sItlUvLuWqr7QfUwb6+Mdl+gdIvdgMatVtJlJFc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
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
