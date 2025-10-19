{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: it may make sense to migrate a subset of this to a devbox (global or local) config

    # Security
    _1password-cli
    sops
    yubikey-manager
    gitleaks

    # Utils
    go-task
    docker-client
    shellcheck
    act

    # General Tools
    gh
    pre-commit
    terraform
    terragrunt
    tflint
    tflint-plugins.tflint-ruleset-aws
    tflint-plugins.tflint-ruleset-google
    # tfvar # TODO: add a nixpkg

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
    trivy
    kubie
    ctlptl
    argocd

    # AI tools
    # open-webui
  ];
}
