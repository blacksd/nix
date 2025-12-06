{pkgs, ...}: {
  programs = {
    k9s = {
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
    # TODO: plugins
    # https://github.com/derailed/k9s/blob/master/plugins/flux.yaml
  };
  home.packages = with pkgs; [
    talosctl
    fluxcd
  ];
  home.shellAliases = {
    k_config_switch_talos = "export KUBECONFIG=\"$HOME/.kube/config_talos\"";
    k_config_switch_tailscale = "export KUBECONFIG=\"$HOME/.kube/config_tailscale\"";
  };
}
