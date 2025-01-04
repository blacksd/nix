{krewfile, ...}: {
  imports = [
    ../../modules/home-manager
    ./home-manager/core.nix
    ./home-manager/ssh.nix
    ./home-manager/tools.nix
    ./home-manager/shell.nix
    krewfile.homeManagerModules.krewfile
  ];
}
