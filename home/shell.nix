{pkgs,lib,...}: {
  
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    meslo-lgs-nf
    oh-my-zsh
    direnv
  ];

  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # initExtraBeforeCompInit = ''
    #   # powerline10k
    #   source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    #   source ${./p10k.zsh}
    # '';
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"
    '';
    
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
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
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./configs;
        file = ".p10k.zsh";
      }
    ];
  };

  programs.direnv = {
      enable = true;
  };

  home.shellAliases = {
    k = "kubectl";

  #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
  #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  };
}
