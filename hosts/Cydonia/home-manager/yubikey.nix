{pkgs, ...}: {
  # Cydonia's age identity lives in a YubiKey PIV slot, so .keys/keys.txt only holds
  # the age-plugin-yubikey identity stub. sops-nix decrypts from a launchd agent at
  # every login and activation: the YubiKey must be plugged in, and the slot must use
  # pin-policy "never" because the agent has no TTY to prompt for a PIN.
  home.packages = [pkgs.age-plugin-yubikey];
  sops.age.plugins = [pkgs.age-plugin-yubikey];
}
