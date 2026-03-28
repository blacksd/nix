{
  pkgs,
  username,
  ...
}: {
  # Minimal home-manager configuration for headless RPi4
  # Does not import the full shared module tree to avoid pulling in
  # GUI apps (VSCode, WezTerm, Kitty) and heavy tooling (AI, k8s)
  imports = [
    ../../modules/home-manager/shared/core.nix
    ../../modules/home-manager/shared/git.nix
    ../../modules/home-manager/shared/shell.nix
    ../../modules/home-manager/shared/ssh.nix
    ../../modules/home-manager/shared/tmux.nix
    ../../modules/home-manager/shared/nvim.nix
    ../../modules/home-manager/shared/gpg.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
