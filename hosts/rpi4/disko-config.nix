{
  # Disko configuration optimized for SD card longevity
  # Using ext4 for lower write amplification and better SD card compatibility
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = {
            # Boot partition - required FAT32 for RPi4 firmware
            boot = {
              size = "512M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "noatime" # Reduce writes
                ];
              };
            };

            # Root partition - ext4 optimized for SD card
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"      # Don't update access times (reduces writes)
                  "nodiratime"   # Don't update directory access times
                  "commit=60"    # Commit interval in seconds (default 5, higher = less writes)
                  "errors=remount-ro" # Remount read-only on errors
                ];
              };
            };
          };
        };
      };
    };
  };
}
