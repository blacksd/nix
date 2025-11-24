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
      plugin = {
        plugins = {
          node-shell = {
            shortCut = "Ctrl-N";
            description = "Open a root shell on a node using the node-shell plugin";
            scopes = ["nodes"];
            command = "sh";
            background = false;
            confirm = false;
            args = [
              "-c"
              "kubectl node-shell --context $CONTEXT $NAME"
            ];
          };
          view-secret = {
            shortCut = "Shift-S";
            description = "View secret (all)";
            scopes = ["secrets"];
            command = "sh";
            background = false;
            args = [
              "-c"
              "kubectl view-secret --context $CONTEXT --namespace $NAMESPACE --all $NAME | less"
            ];
          };
          neat_nodes = {
            shortCut = "Ctrl-T";
            description = "Clean manifest with kubectl neat (nodes)";
            scopes = ["nodes"];
            command = "sh";
            background = false;
            args = [
              "-c"
              "kubectl neat get -- node --context $CONTEXT $NAME --output yaml | less"
            ];
          };
          neat_non_nodes = {
            shortCut = "Ctrl-T";
            description = "Clean manifest with kubectl neat (non-nodes)";
            scopes = ["pods" "deployments" "statefulsets" "secrets" "configmaps"];
            command = "sh";
            background = false;
            args = [
              "-c"
              "kubectl neat get -- $RESOURCE_NAME --context $CONTEXT --namespace $NAMESPACE $NAME --output yaml | less"
            ];
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
        };
      };
    };
    # TODO: plugins
    # https://github.com/derailed/k9s/blob/master/plugins/log-stern.yaml
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
  home.packages = with pkgs; [
    cilium-cli
    kubeconform
    kubectl
    kustomize
    regctl
    kubernetes-helm
    (pkgs.wrapHelm pkgs.kubernetes-helm {
      plugins = [
        pkgs.kubernetes-helmPlugins.helm-diff
        pkgs.kubernetes-helmPlugins.helm-secrets
        pkgs.kubernetes-helmPlugins.helm-unittest
      ];
    })
  ];
  home.shellAliases = {
    k = "kubectl";

    k_config_off = "unset KUBECONFIG";
    k_conform = "kubeconform -strict -ignore-missing-schemas -summary -schema-location default -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' -verbose -summary";
  };
}
