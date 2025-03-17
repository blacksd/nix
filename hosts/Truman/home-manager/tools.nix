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
    kubectl
    trivy
    kubie
    ctlptl
    argocd
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = [
        pkgs.kubernetes-helmPlugins.helm-diff
        pkgs.kubernetes-helmPlugins.helm-secrets
        pkgs.kubernetes-helmPlugins.helm-unittest
      ];
    })

    # AI tools
    # open-webui
  ];

  # home.file = {
  #   ".local/share/gh/extensions/gh-clone-org" = {
  #     enable = true;
  #     source = builtins.fetchurl {
  #       url = "https://raw.githubusercontent.com/matt-bartel/gh-clone-org/refs/heads/master/gh-clone-org";
  #       sha256 = "a3d2732de7b6cd91d5bdb543f2007bb048754624dc159bb4b1436e5e293c165f";
  #     };
  #   };
  # };

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
        "ctx"
        "explore"
        "kor"
        "kyverno"
        "neat"
        "ns"
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
