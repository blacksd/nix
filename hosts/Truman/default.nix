{
  home-manager,
  specialArgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin
    ./apps.nix
    ./ai.nix
    home-manager.darwinModules.home-manager
  ];

  # nix-darwin state version (uses integers, not strings)
  # This should match the nix-darwin version when the host was first created
  system.stateVersion = 5;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "home-manager-backup";
    users.${specialArgs.username} = import ./home.nix;
  };
}
