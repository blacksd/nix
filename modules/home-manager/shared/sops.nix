{
  config,
  pkgs,
  lib,
  sops-nix,
  ...
}: {
  imports = [
    sops-nix.homeManagerModules.sops
  ];

  # sops-nix home-manager configuration
  sops = {
    # Reuse the same SOPS_AGE_KEY_FILE path from age.nix configuration
    age.keyFile = config.programs.zsh.sessionVariables.SOPS_AGE_KEY_FILE;
    defaultSopsFile = lib.mkDefault null;
  };
}
