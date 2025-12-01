{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File systems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/84aba5ee-f02d-4145-b4ad-d8c829b3ca9b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CD8C-6606";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/5c8dec9b-59a8-4241-a390-5f1c9e88000a";}
  ];

  # Networking
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp88s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  # Enable Wake-on-LAN on wired interface
  networking.interfaces.enp88s0.wakeOnLan.enable = true;

  # Platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
