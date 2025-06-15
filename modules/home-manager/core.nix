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
  ];

  programs = {
    java = {
      enable = true;
    };
  };
}
