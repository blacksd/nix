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
    asciinema
    asciinema-agg
    jnv # jq with dynamic filtering
    jc # json converter

    # nix
    alejandra
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
