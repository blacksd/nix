{...}: {
  # Host-specific home-manager overrides for Truman
  imports = [
    ../../modules/darwin/home-manager

    # Host-specific HM modules
    ./home-manager/ai.nix
    ./home-manager/core.nix
    ./home-manager/k8s.nix
    ./home-manager/shell.nix
    ./home-manager/ssh.nix
    ./home-manager/tools.nix
  ];
}
