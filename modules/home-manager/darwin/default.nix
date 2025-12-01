{...}: {
  # Import shared home-manager modules first
  imports = [
    ../shared # Shared home-manager modules

    # Darwin-specific modules
    ./ai.nix
    ./core.nix
    ./gpg.nix
  ];
}
