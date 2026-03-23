{
  pkgs,
  nixpkgs-unstable,
  ...
}: let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  home.packages =
    (with pkgs; [
      asciinema
      asciinema-agg
    ])
    ++ (with pkgs-unstable; [
      codex
    ]);
}
