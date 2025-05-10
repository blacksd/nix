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
}
