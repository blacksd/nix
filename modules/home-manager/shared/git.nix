{
  lib,
  useremail,
  pkgs,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        prvw = "pr view --web";
        prcw = "pr create --web";
        rvw = "repo view --web";
      };
    };
    extensions = with pkgs; [
      gh-s
      gh-f
      gh-poi
    ];
  };
  # TODO: add a package for matt-bartel/gh-clone-org or rm3l/gh-org-repo-sync; can't do this b/c the symlink will fail
  # home.file = {
  #   ".local/share/gh/extensions/gh-clone-org" = {
  #     enable = true;
  #     source = builtins.fetchurl {
  #       url = "https://raw.githubusercontent.com/matt-bartel/gh-clone-org/refs/heads/master/gh-clone-org";
  #       sha256 = "a3d2732de7b6cd91d5bdb543f2007bb048754624dc159bb4b1436e5e293c165f";
  #     };
  #   };
  # };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Marco Bulgarini";
    userEmail = useremail;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    signing = {
      key = useremail;
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
      };
    };

    aliases = {
      # common aliases
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      bsc = "branch --show-current";
      dc = "diff --cached";

      css = "commit --gpg-sign --signoff";
      oops = "commit --amend --no-edit";
      daje = "push --force-with-lease";
      root = "rev-parse --show-toplevel";
    };
  };
}
