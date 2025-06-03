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
          view-secret = {
            shortCut = "Shift-S";
            description = "View secret (all)";
            scopes = ["secrets"];
            command = "sh";
            background = false;
            args = [
              "-c"
              "kubectl view-secret --context $CLUSTER --namespace $NAMESPACE --all $NAME | less"
            ];
          };
          disable-auto-sync = {
            shortCut = "Shift-Y";
            confirm = false;
            scopes = [
              "applications.argoproj.io"
            ];
            description = "Disable ArgoCD sync";
            command = "kubectl";
            background = false;
            args = [
              "patch"
              "applications"
              "--namespace"
              "$NAMESPACE"
              "$NAME"
              "--type=json"
              "-p=[{\"op\":\"replace\", \"path\": \"/spec/syncPolicy\", \"value\": {}}]"
            ];
          };
        };
      };
    };
  };
}
