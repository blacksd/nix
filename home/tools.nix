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
    kubelogin

    # Kubernetes
    kubectl
    trivy
    kubie
    argocd
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = [
        pkgs.kubernetes-helmPlugins.helm-diff
        pkgs.kubernetes-helmPlugins.helm-secrets
        pkgs.kubernetes-helmPlugins.helm-unittest
      ];
    })
  ];
  programs = {
    k9s = {
      enable = true;
    };
    krewfile = {
      # FIXME: upon installation, krew pkg should update the plugin index
      enable = true;
      plugins = [
        "access-matrix"
        "blame"
        "cert-manager"
        "explore"
        "kor"
        "neat"
        "pv-migrate"
        "resource-capacity"
        "stern"
        "view-cert"
        "view-secret"
        "who-can"
      ];
    };
  };
}
