{pkgs, ...}: {
  programs = {
    k9s = {
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
  };
}
