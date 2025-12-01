{...}: {
  # Darwin-specific k8s configuration
  # Base k8s config is in shared/k8s.nix

  programs = {
    # krewfile is darwin-specific (only available in darwin inputs)
    krewfile = {
      enable = true;
      plugins = [
        "access-matrix"
        "blame"
        "cert-manager"
        "cnpg"
        "ctx"
        "deprecations"
        "explore"
        "kor"
        "kyverno"
        "neat"
        "ns"
        "oidc-login"
        "pv-migrate"
        "resource-capacity"
        "stern"
        "view-cert"
        "view-secret"
        "who-can"
        "node-shell"
      ];
    };
  };
}
