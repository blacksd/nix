{
  home-manager,
  specialArgs,
  ...
}: {
  imports = [
    ../../modules/base
    ./apps.nix
    ./aerospace.nix
    home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "home-manager-backup";
    users.${specialArgs.username} = import ./home-manager.nix;
  };
}
