{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Install monitoring tools
  environment.systemPackages = with pkgs; [
    lm_sensors # For temperature monitoring
  ];

  # Boot configuration for RPi4
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;

    # Enable additional firmware
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];

    loader = {
      grub.enable = false;
      # Enable extlinux bootloader for Raspberry Pi
      # This ensures boot configuration is updated on each rebuild
      generic-extlinux-compatible.enable = true;
    };
  };

  # PWM Fan Control with native device tree overlay
  # Fan connected to GPIO 14 (TXD pin)
  # Provides variable speed control based on temperature
  hardware.deviceTree = {
    enable = true;
    filter = "*rpi-4-*.dtb";
  };

  # Note: PWM fan control is configured via /boot/config.txt
  # The pwm-fan overlay provides variable speed control based on temperature
  # Current configuration: dtoverlay=pwm-fan,gpiopin=14
  #
  # To verify fan is working after reboot:
  #   ls /sys/class/hwmon/  # Should show pwm-fan device
  #   cat /sys/class/thermal/thermal_zone0/temp  # Check temperature
  #
  # The pwm-fan overlay automatically manages fan speed based on CPU temperature

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [pkgs.raspberrypiWirelessFirmware];

  # GPU acceleration (optional, can enable later)
  # hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Audio (optional, can enable later)
  # hardware.raspberry-pi."4".audio.enable = true;

  # File systems configuration
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = ["noatime" "nodiratime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/FIRMWARE";
    fsType = "vfat";
    options = ["noatime"];
  };

  # Swap (optional, generally not recommended for SD cards)
  swapDevices = [];

  # Enable hardware watchdog
  # hardware.watchdog.enable = true;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
