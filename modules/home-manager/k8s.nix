{pkgs, ...}: {
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
        "cnpg"
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
  home.packages = with pkgs; [
    kubeconform
    kubectl
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = [
        pkgs.kubernetes-helmPlugins.helm-diff
        pkgs.kubernetes-helmPlugins.helm-secrets
        pkgs.kubernetes-helmPlugins.helm-unittest
      ];
    })
  ];
}
