{pkgs, ...}: {
  home.packages = with pkgs; [
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
