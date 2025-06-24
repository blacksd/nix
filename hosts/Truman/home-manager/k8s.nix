{pkgs, ...}: {
  programs = {
    k9s = {
      hotkey = {
        hotKeys = {
          shift-0 = {
            shortCut = "Shift-0";
            description = "ArgoCD Applications (argocd namespace)";
            command = "applications.argoproj.io argocd";
          };
        };
      };
      plugin = {
        plugins = {
          enable-auto-sync = {
            shortCut = "s";
            confirm = true;
            scopes = [
              "applications.argoproj.io"
            ];
            description = "Enable ArgoCD auto-sync";
            command = "kubectl";
            background = false;
            args = [
              "--context=$CLUSTER"
              "--namespace=$NAMESPACE"
              "patch"
              "applications"
              "$NAME"
              "--type=json"
              "--patch=[{\"op\":\"replace\", \"path\": \"/spec/syncPolicy\", \"value\": {\"automated\": {} }}]"
            ];
          };
          disable-auto-sync = {
            shortCut = "Shift-S";
            confirm = true;
            scopes = [
              "applications.argoproj.io"
            ];
            description = "Disable ArgoCD auto-sync";
            command = "kubectl";
            background = false;
            args = [
              "--context=$CLUSTER"
              "--namespace=$NAMESPACE"
              "patch"
              "applications"
              "$NAME"
              "--type=json"
              "--patch=[{\"op\":\"replace\", \"path\": \"/spec/syncPolicy\", \"value\": {} }]"
            ];
          };
          ephemeral-container = {
            shortCut = "Shift-E";
            confirm = false;
            scopes = [
              "pods"
            ];
            description = "Run ephemeral container on a pod";
            command = "kubectl";
            background = false;
            args = [
              "--context=$CLUSTER"
              "--namespace=$NAMESPACE"
              "debug"
              "$NAME"
              "--tty"
              "--stdin"
              "--image=nicolaka/netshoot"
              "--profile=general"
            ];
          };
        };
      };
    };
  };
}
