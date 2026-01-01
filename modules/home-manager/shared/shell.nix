{
  pkgs,
  lib,
  ...
}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    oh-my-zsh
    direnv
  ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    bat = {
      enable = true;
      themes = {
        dracula = {
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          };
          file = "Dracula.tmTheme";
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;

      initContent = ''
        export PATH="$HOME/.krew/bin:$HOME/.local/bin:$HOME/go/bin:$PATH"

        # Devbox globals setup
        eval "$(devbox global shellenv)"

        # iTerm2 tab color management
        source ${./configs/iterm2-tab-color.sh}
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
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./configs;
          file = ".p10k.zsh";
        }
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

  home.shellAliases = {
    cdrepo = "cd $HOME/Repositories";
    cdnixdarwin = "cd $HOME/.config/nix-darwin";
    cdgitroot = "cd $(git root)";
    cdtemp = "cd $HOME/Temp";

    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    plist_to_json = "python3 -c 'import plistlib,sys,json,base64; print(json.dumps(plistlib.loads(sys.stdin.read().encode(\"utf-8\")), default=lambda o:\"base64:\"+base64.b64encode(o).decode(\"ascii\")))'";
    generate_password = "python3 ${./configs/generate_password.py}";
    my_ip = "echo \"$(curl -s ifconfig.co)/32\"";
  };

  home.file = {
    ".kube/config" = {
      text = "";
    };
    "Library/Application\ Support/iTerm2/DynamicProfiles/iTerm2-nix-profiles.plist.json" = {
      enable = true;
      source = lib.mkForce (lib.cleanSource ./configs/iTerm2-nix-profiles.plist.json);
    };
  };
}
