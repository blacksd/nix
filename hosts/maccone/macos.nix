{nix-plist-manager, ...}: {
  # macOS system-scope settings (applied as root) via nix-plist-manager.
  # Drift against the live Mac: `task plist-drift`
  imports = [nix-plist-manager.darwinModules.default];

  programs.nix-plist-manager = {
    enable = true;
    options = {
      applications.systemSettings = {
        battery.options = {
          preventAutomaticSleepingOnPowerAdapterWhenTheDisplayIsOff = false;
          slightlyDimTheDisplayOnBattery = true;
          wakeForNetworkAccess = "Only on Power Adapter";
        };

        # Time zone stays in `time.timeZone` (modules/system/darwin/system.nix).
        general = {
          sharing = {
            contentCaching = false;
            fileSharing = false;
            printerSharing = false;
            remoteApplicationScripting = false;
            remoteApplicationScriptingOptions.allowAccessFor = "Only these users";
            remoteManagement = false;
            screenSharing = false;
            screenSharingOptions.allowAccessFor = "Only these users";
          };
          softwareUpdate = {
            automaticallyDownloadNewUpdatesWhenAvailable = true;
            automaticallyInstallApplicationUpdatesFromTheAppStore = false;
          };
        };

        lockScreen = {
          turnDisplayOffOnBatteryWhenInactive = "For 2 minutes";
          turnDisplayOffOnPowerAdapterWhenInactive = "For 10 minutes";
        };

        network.firewall = {
          firewall = false;
          options = {
            automaticallyAllowBuiltInSoftwareToReceiveIncomingConnections = true;
            automaticallyAllowDownloadedSignedSoftwareToReceiveIncomingConnections = true;
            blockAllIncomingConnections = false;
            enableStealthMode = false;
          };
        };

        privacyAndSecurity.analyticsAndImprovements = {
          shareMacAnalytics = true;
          shareWithAppDevelopers = true;
        };
      };
    };
  };
}
