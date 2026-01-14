{
  pkgs,
  nixpkgs-unstable,
  ...
}: let
  # Get packages from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs-unstable; [
    codex
    yek
    ast-grep
    goose-cli
  ];
}
