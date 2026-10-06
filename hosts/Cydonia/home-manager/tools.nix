{
  config,
  lib,
  pkgs,
  herdr,
  ...
}: {
  # aws-vault creates its keychain locking after 5 minutes idle; keep it open for
  # 8 hours (still locks on sleep). No-op until the keychain exists.
  home.activation.awsVaultKeychainTimeout = lib.hm.dag.entryAfter ["writeBoundary"] ''
    keychain="${config.home.homeDirectory}/Library/Keychains/aws-vault.keychain-db"
    if [ -e "$keychain" ]; then
      run /usr/bin/security set-keychain-settings -l -u -t 28800 "$keychain"
    fi
  '';

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
    herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr
    # sofka installed via programs.sofka HM module (see home-manager/k8s.nix)

    # AI tools
    # open-webui
  ];
}
