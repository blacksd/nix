{
  pkgs,
  lib,
  ...
}: {
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    # fonts for Powerline10k
    # meslo-lgs-nf
    oh-my-zsh
    direnv
    # nerdfonts
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
    # (pkgs.nerdfonts.override {
    #   fonts = [
    #     "Meslo"
    #     # symbols icon only
    #     "NerdFontsSymbolsOnly"
    #     # Characters
    #     "FiraCode"
    #     "JetBrainsMono"
    #     "Iosevka"
    #   ];
    # })
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      export PATH="$HOME/.krew/bin:$HOME/.local/bin:$HOME/go/bin:$PATH"

      # Devbox globals setup
      eval "$(devbox global shellenv)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "macos"
        "git"
        "direnv"
        "sudo"
        "docker"
        "kubectl"
        "fzf"
      ];
    };

    history = {
      ignoreAllDups = true;
      save = 128000;
      size = 256000;
    };

    # This is another neat way to do it
    # https://github.com/NixOS/nixpkgs/issues/154696#issuecomment-1238433989
    plugins = [
      {
        # A prompt will appear the first time to configure it properly
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      # {
      #   name = "powerlevel10k-config";
      #   src = lib.cleanSource ./configs;
      #   file = ".p10k.zsh";
      # }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.shellAliases = {
    k = "kubectl";

    cdrepo = "cd $HOME/Repositories";
    cdnixdarwin = "cd $HOME/.config/nix-darwin";
    cdgitroot = "cd $(git root)";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    k_config_off = "unset KUBECONFIG";
  };

  home.file = {
    ".kube/config" = {
      text = "";
    };
  };
}
