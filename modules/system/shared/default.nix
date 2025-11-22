{...}: {
  # Shared system modules (cross-platform)
  imports = [
    ./nix-settings.nix
    ./users.nix
    ./apps.nix
    ./shell.nix
  ];
}
