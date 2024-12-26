{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    xz
    p7zip

    # utils
    netcat
    ripgrep
    fzf
    tree
    gnused
    gnutar
    gnugrep
    gawk
    jnv
    jc
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
