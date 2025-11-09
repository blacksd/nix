{...}: {
  # Host-specific home-manager overrides for simpleton
  imports = [
    ../../modules/darwin/home-manager

    # Host-specific HM modules
    ./home-manager/core.nix
    ./home-manager/gaming.nix
    ./home-manager/k8s.nix
    ./home-manager/ssh.nix
  ];
}
