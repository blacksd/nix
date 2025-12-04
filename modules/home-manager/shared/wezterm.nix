{
  pkgs,
  nixpkgs-unstable,
  ...
}: let
  # Get wezterm from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = ''
      ${builtins.readFile ./configs/wezterm.lua}
    '';
    package = pkgs-unstable.wezterm;
  };
}
