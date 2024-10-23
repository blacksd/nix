{pkgs,...}: {
  
  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    oh-my-zsh
    direnv
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin:$HOME/go/bin"
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
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
