{
  krewfile,
  claude-code,
  ...
}: {
  # Import shared home-manager modules first
  imports = [
    ../../shared/home-manager

    # Darwin-specific modules
    ./ai.nix
    ./core.nix
    ./gpg.nix
    ./k8s.nix

    # External darwin-specific modules
    krewfile.homeManagerModules.krewfile
    claude-code.homeManagerModules.claude-code
  ];
}
