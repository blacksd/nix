{pkgs, ...}: {
  home.packages = with pkgs; [
    # mandatory lulz
    neofetch

    # archives
    zip
    unzip
    zstd
    xz
    p7zip
    gnutar

    # utils
    netcat
    ripgrep
    tree
    gnused
    gnugrep
    gawk
    jnv
    jc
    localsend
    go-task

    # I don't know what fun is
    devenv
  ];

  programs = {
    java = {
      enable = true;
    };
  };
}
