{...}: {
  # NixOS system modules
  imports = [
    ../shared  # Shared cross-platform modules

    # NixOS-specific system modules
    ./nix-core.nix
  ];
}
