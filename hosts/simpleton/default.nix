{
  home-manager,
  specialArgs,
  ...
}: {
  imports = [
    ../../modules/system/darwin
    ./apps.nix
    ./aerospace.nix
    ./jankyborders.nix
    home-manager.darwinModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    backupFileExtension = "home-manager-backup";
    users.${specialArgs.username} = import ./home.nix;
  };
}
