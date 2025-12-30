{...}: {
  # Import shared home-manager modules first
  imports = [
    ../shared # Shared home-manager modules

    # Darwin-specific modules
    ./colima.nix
    ./core.nix
    ./gpg.nix
  ];
}
