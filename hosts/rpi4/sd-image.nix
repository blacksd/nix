{
  lib,
  modulesPath,
  ...
}: {
  # Import the standard NixOS SD image builder for aarch64
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # SD image settings
  sdImage = {
    compressImage = true;
    firmwareSize = 512; # MB - enough for bootloader + kernels
  };

  # Disable disko and hardware-configuration.nix fileSystems —
  # the sd-image module provides its own partition/filesystem layout
  disko.devices = lib.mkForce {};
  fileSystems = lib.mkForce {};
}
