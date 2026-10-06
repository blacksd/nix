{pkgs, ...}: {
  # Cydonia's age identity is bound to this Mac's Secure Enclave (age-plugin-se), so
  # .keys/keys.txt is useless on any other machine. sops-nix decrypts from a launchd
  # agent at every login and activation with no UI to prompt, hence the key is
  # generated with `--access-control none`.
  home.packages = [pkgs.age-plugin-se];
  sops.age.plugins = [pkgs.age-plugin-se];
}
