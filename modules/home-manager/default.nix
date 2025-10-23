{
  username,
  krewfile,
  claude-code,
  ...
}: {
  # import sub modules
  imports = [
    ./core.nix
    ./git.nix
    ./gpg.nix
    ./k8s.nix
    ./kitty.nix
    ./nvim.nix
    ./shell.nix
    ./tmux.nix
    ./wezterm.nix
    claude-code.homeManagerModules.claude-code
    krewfile.homeManagerModules.krewfile
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";

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
