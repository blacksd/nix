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
    jq # A lightweight and flexible command-line JSON processor
    jnv # jq with dynamic filtering
    yq-go # yaml processer https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    tree
    gnused
    gnutar
    gawk

    # nix
    alejandra

    # productivity
    sops
    yubikey-manager
    go-task
    docker-client
    _1password
  ];

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
