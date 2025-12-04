{
  pkgs,
  username,
  lib,
  krewfile,
  ...
}: {
  # Import all shared home-manager modules
  imports = [
    ./age.nix
    ./ai.nix
    ./claude-code
    ./core.nix
    ./git.nix
    ./gpg.nix
    ./k8s.nix
    ./kitty.nix
    ./nvim.nix
    ./shell.nix
    ./ssh.nix
    ./sops.nix
    ./tmux.nix
    ./wezterm.nix
    # External modules
    krewfile.homeManagerModules.krewfile
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    # homeDirectory is set in platform-specific modules (darwin/nixos)

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
