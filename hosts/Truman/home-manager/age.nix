{
  pkgs,
  config,
  hostname,
  ...
}: let
  ageKeyPath = ".config/nix-darwin/hosts/${hostname}/.keys/keys.txt";
in {
  home.packages = with pkgs; [
    age
  ];

  programs.zsh = {
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/${ageKeyPath}";
    };
  };
}
