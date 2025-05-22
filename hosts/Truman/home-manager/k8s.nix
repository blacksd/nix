{pkgs, ...}: {
  programs = {
    k9s = {
      plugin = {
        plugins = {
          view-secret = {
            shortCut = "Shift-S";
            description = "View secret (all)";
            scopes = ["secret"];
            command = "sh";
            background = false;
            args = [
              "-c"
              "kubectl view-secret --context $CLUSTER --namespace $NAMESPACE --all $NAME | less"
            ];
          };
        };
      };
    };
  };
}
