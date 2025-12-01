{...}: {
  # Import shared home-manager modules
  imports = [
    ../shared  # Shared home-manager modules

    # NixOS-specific modules
    ./apps.nix
    ./wezterm.nix
  ];
}
