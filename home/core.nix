{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    xz
    p7zip

    # utils
    netcat
    ripgrep # recursively searches directories for a regex pattern
    fzf # A command-line fuzzy finder
    tree
    gnused
    gnutar
    gnugrep
    gawk
    jnv # jq with dynamic filtering
    jc # json converter

    # nix
    alejandra

    # productivity
    sops
    yubikey-manager
    go-task
    docker-client
    shellcheck

    # Security
    _1password
  ];

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    java = {
      enable = true;
    };
  };
}
