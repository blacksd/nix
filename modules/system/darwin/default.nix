{...}: {
  # Darwin system modules
  imports = [
    ../shared  # Shared cross-platform modules
    ./apps.nix
    ./host-users.nix
    ./nix-core.nix
    ./system.nix
  ];
}
