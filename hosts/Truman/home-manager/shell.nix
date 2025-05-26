{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    initContent = ''
      export PATH="$KREW_ROOT/bin:$HOME/.local/bin:$HOME/go/bin:$PATH"

      # Devbox globals setup
      eval "$(devbox global shellenv)"

      ## Include some useful helper functions
      # Visual Studio Code
      source ${./shell-functions/vscode.zsh}
      # AWS
      source ${./shell-functions/aws.zsh}

      # Try to resolve VScode stuff
      [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
    '';

    oh-my-zsh = {
      plugins = [
        "aws"
      ];
    };
  };

  home.shellAliases = {
    # TODO: touch these
    k_config_switch_aws = "export KUBECONFIG=\"$HOME/.kube/config_aws\"";
    k_config_switch_azure = "export KUBECONFIG=\"$HOME/.kube/config_azure\"";
    k_config_switch_gcp = "export KUBECONFIG=\"$HOME/.kube/config_gcp\"";

    hmqc_repo = "pushd \"$(find $HOME/Repositories -type d -maxdepth 1 -exec basename {} \\; | sort | fzf)\"";
  };
}
