{...}: {
  # Host-specific home-manager overrides for Truman
  imports = [
    ../../modules/home-manager/darwin

    # Host-specific HM modules
    ./home-manager/ai.nix
    ./home-manager/colima.nix
    ./home-manager/core.nix
    ./home-manager/k8s.nix
    ./home-manager/shell.nix
    ./home-manager/ssh.nix
    ./home-manager/tools.nix
  ];
}
