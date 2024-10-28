{
  lib,
  useremail,
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
        prw = "pr view --web";
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Marco Bulgarini";
    userEmail = useremail;

    # includes = [
    #   {
    #     # use diffrent email & name for work
    #     path = "~/Repositories/.gitconfig";
    #     condition = "gitdir:~/Repositories/";
    #   }
    # ];

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
      # ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      # ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      # cm = "commit -m";
      # ca = "commit -am";
      dc = "diff --cached";
      # amend = "commit --amend -m";
      oops = "commit --amend --no-edit";
      daje = "git push --force-with-lease";

      # # aliases for submodule
      # update = "submodule update --init --recursive";
      # foreach = "submodule foreach";
    };
  };
}
