{
  config,
  pkgs,
  username,
  useremail,
  ...
}: {
  imports = [
    ../../modules/home-manager/nixos
    ../../modules/home-manager/shared
    ./desktop-environments/hyprland/home.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
