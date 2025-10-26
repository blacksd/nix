{
  pkgs,
  config,
  hostname,
  ...
}: let
  # INFO: this assumes the flake is in ~/.config/nix-darwin - any different scenario must be handled accordingly
  ageKeyPath = "${config.home.homeDirectory}/.config/nix-darwin/hosts/${hostname}/.keys/keys.txt";
in {
  home.packages = with pkgs; [
    age
  ];

  programs.zsh = {
    sessionVariables = {
      SOPS_AGE_KEY_FILE = ageKeyPath;
    };
  };
}
