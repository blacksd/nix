{pkgs, ...}: {
  home.packages = with pkgs; [
    # mandatory lulz
    neofetch

    # archives
    zip
    unzip
    xz
    p7zip
    gnutar

    # utils
    netcat
    ripgrep
    fzf
    tree
    gnused
    gnugrep
    gawk
    jnv
    jc
    localsend
    go-task
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
