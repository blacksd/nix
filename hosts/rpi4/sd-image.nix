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

  # Disable disko — the sd-image module provides its own partition/filesystem layout
  disko.devices = lib.mkForce {};

  # The generic sd-image-aarch64 module adds dw-hdmi to initrd, but the
  # RPi4 kernel doesn't include that module (it uses vc4 instead)
  boot.initrd.availableKernelModules = lib.mkForce ["xhci_pci" "usbhid" "usb_storage"];

  # Override hardware-configuration.nix fileSystems that conflict with sd-image module
  fileSystems."/" = lib.mkForce {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  fileSystems."/boot" = lib.mkForce {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
  };
}
