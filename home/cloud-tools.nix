{pkgs, ...}: {
  home.packages = with pkgs; [
    # General Tools
    gh
    pre-commit

    # AWS
    awscli2
    aws-vault
    
    # Google Cloud w/GKE auth
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])

    # Kubernetes
    kubectl
  ];
}