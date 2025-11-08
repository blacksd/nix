{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Raspberry Pi 4 specific configuration

  # Boot configuration for RPi4
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;

    # Enable additional firmware
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [pkgs.raspberrypiWirelessFirmware];

  # GPU acceleration (optional, can enable later)
  # hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Audio (optional, can enable later)
  # hardware.raspberry-pi."4".audio.enable = true;

  # File systems are managed by disko (see disko-config.nix)
  # Swap (optional, generally not recommended for SD cards)
  swapDevices = [];

  # Enable hardware watchdog
  # hardware.watchdog.enable = true;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
