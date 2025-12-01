{
  pkgs,
  username,
  lib,
  ...
}: {
  # Import all shared home-manager modules
  imports = [
    ./age.nix
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
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;

    # Platform-aware homeDirectory
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
