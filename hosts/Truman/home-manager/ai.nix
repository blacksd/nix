{
  pkgs,
  nixpkgs-unstable,
  ...
}: let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs; [
    codex
  ];

  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
  };
}
