{
  pkgs,
  hl,
  ...
}: {
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
    jq
    jnv
    jc # json converter
    hl.packages.${pkgs.system}.default
    yq-go # yaml processer https://github.com/mikefarah/yq
    localsend
    go-task
    fd

    # I don't know what fun is
    qrencode
  ];

  programs = {
    java = {
      enable = true;
    };
  };
}
