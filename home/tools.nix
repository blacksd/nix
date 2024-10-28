{pkgs, ...}: {
  home.packages = with pkgs; [
    # TODO: it may make sense to migrate a subset of this to a devbox (global or local) config

    # Utils
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq

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
    aws-vault

    # Google Cloud w/GKE auth
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])

    # Azure
    (azure-cli.withExtensions [azure-cli.extensions.aks-preview])

    # Kubernetes
    kubectl
    krew
    trivy
    argocd
  ];
}
