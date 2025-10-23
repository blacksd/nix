{
  pkgs,
  config,
  ...
}: let
  yubikeyIdentity = ''
    #       Serial: 17684738, Slot: 6
    #         Name: sops-nix Truman
    #      Created: Thu, 23 Oct 2025 14:51:35 +0000
    #   PIN policy: Once   (A PIN is required once per session, if set)
    # Touch policy: Cached (A physical touch is required for decryption, and is cached for 15 seconds)
    #    Recipient: age1yubikey1qg77kfk3fgw332qdjhl69sn3g2j3479kl59r27xe6up8eew3cd77ju0365g
    AGE-PLUGIN-YUBIKEY-1QTVS6QV8EXC90JGK42W6Z
  '';
  sopsKeysPath = "Library/Application Support/sops/age/keys.txt";
  yubikeyIdentityPath = ".config/age-plugin-yubikey/identities.txt";
in {
  home.packages = with pkgs; [
    age
    age-plugin-yubikey
  ];
  home.file."${yubikeyIdentityPath}".text = yubikeyIdentity;
  programs.zsh = {
    sessionVariables = {
      # NOTE: if yubikey is lost, damaged or stolen, place your backup age key
      # in ~/Library/Application Support/sops/age/keys.txt and switch the following assignment:
      # SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/${sopsKeysPath}";
      SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/${yubikeyIdentityPath}";
    };
  };
}
