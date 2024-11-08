{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: it may make sense to migrate a subset of this to a devbox (global or local) config

    # Security
    _1password
    sops
    yubikey-manager

    # Utils
    go-task
    docker-client
    shellcheck
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq

    # Security
    gitleaks

    # General Tools
    gh
    pre-commit
    terraform
    terragrunt
    tflint
    tflint-plugins.tflint-ruleset-aws
    tflint-plugins.tflint-ruleset-google

    # AWS
    awscli2
    eksctl
    aws-vault

    # Google Cloud w/GKE auth
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])

    # Azure
    (azure-cli.withExtensions [
      azure-cli.extensions.aks-preview
      azure-cli.extensions.account
    ])

    # Kubernetes
    kubectl
    krew
    trivy
    argocd
  ];
  programs = {
    k9s = {
      enable = true;
    };
  };
  #   { inputs, pkgs, ... }: {
  #   imports = [
  #     # ...
  #     inputs.krewfile.homeManagerModules.krewfile
  #   ];

  #   programs.krewfile = {
  #     enable = true;
  #     krewPackage = pkgs.krew;
  #     indexes = { foo = "https://github.com/nilic/kubectl-netshoot.git" };
  #     plugins = [
  #       "foo/some-package"
  #       "explore"
  #       "modify-secret"
  #       "neat"
  #       "oidc-login"
  #       "pv-migrate"
  #       "stern"
  #     ];
  #   };
  # }

  # programs.krewfile = {
  #   enable = true;
  #   krewPackage = pkgs.krew;
  #   plugins = [
  #     "explore"
  #     # "modify-secret"
  #     "neat"
  #     # "oidc-login"
  #     # "pv-migrate"
  #     "view-cert"
  #     "view-secret"
  #     "stern"
  #   ];
  # };
}
