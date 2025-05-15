{pkgs, ...}: {
  programs = {
    k9s = {
      enable = true;
      settings = {
        k9s = {
          ui = {
            headless = true;
            # defaultsToFullScreen = true;
          };
          logger = {
            buffer = 4000;
          };
        };
      };
      hotkey = {
        hotKeys = {
          shift-k = {
            shortCut = "Shift-K";
            description = "Flux Kustomizations (all namespaces)";
            command = "kustomize.toolkit.fluxcd.io/v1/kustomizations all";
          };
          shift-h = {
            shortCut = "Shift-H";
            description = "HelmReleases (all namespaces)";
            command = "helmreleases.helm.toolkit.fluxcd.io all";
          };
          shift-f = {
            shortCut = "Shift-F";
            description = "FluxInstances (all namespaces)";
            command = "fluxinstances.fluxcd.controlplane.io all";
          };
        };
      };
    };
    # TODO: plugins
    # https://github.com/derailed/k9s/blob/master/plugins/flux.yaml
    # https://github.com/derailed/k9s/blob/master/plugins/log-stern.yaml
    krewfile = {
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
