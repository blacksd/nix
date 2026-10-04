{
  config,
  nix-plist-manager,
  username,
  ...
}: let
  home = config.users.users.${username}.home;
in {
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
        };

        lockScreen = {
          turnDisplayOffOnBatteryWhenInactive = "For 2 minutes";
          turnDisplayOffOnPowerAdapterWhenInactive = "For 10 minutes";
        };

        network.firewall = {
          firewall = true;
          options = {
            automaticallyAllowBuiltInSoftwareToReceiveIncomingConnections = true;
            automaticallyAllowDownloadedSignedSoftwareToReceiveIncomingConnections = true;
            blockAllIncomingConnections = false;
            enableStealthMode = true;
          };
        };

        privacyAndSecurity.analyticsAndImprovements.shareMacAnalytics = true;

        wiFi = {
          askToJoinNetworks = "Off";
          requireAdministratorAuthorizationTo = {
            changeNetworks = false;
            turnWiFiOnOrOff = false;
          };
        };
      };
    };
  };

  # Dock contents: rebuilt from these lists on every switch; manual pins are dropped.
  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/System/Applications/App Store.app"
      "/System/Applications/Calendar.app"
      "/System/Applications/System Settings.app"
      "/Applications/Logseq.app"
      "/Applications/Slack.app"
      "/Applications/Google Chrome.app"
      "/System/Applications/Notes.app"
      "/Applications/Spotify.app"
      "/Applications/1Password.app"
      "/Applications/zoom.us.app"
      "/Applications/iTerm.app"
      "${home}/Applications/Home Manager Apps/WezTerm.app"
      "/Applications/Discord.app"
    ];
    persistent-others = [
      {
        folder = {
          path = "${home}/Downloads";
          arrangement = "date-added";
          showas = "fan";
        };
      }
    ];
  };
}
