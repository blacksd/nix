{nix-plist-manager, ...}: {
  # macOS user-scope settings via nix-plist-manager.
  # Drift against the live Mac: `task plist-drift`
  imports = [nix-plist-manager.homeManagerModules.default];

  programs.nix-plist-manager = {
    enable = true;
    options = {
      applications = {
        finder = {
          menuBar.view.showSidebar = true;
          settings.general.showTheseItemsOnTheDesktop = {
            cdsDvdsAndiPods = true;
            externalDisks = true;
            hardDisks = false;
          };
        };

        systemSettings = {
          accessibility.pointerControl.trackpadOptions = {
            # dragging = "Off" is omitted: upstream emits `tap=$(defaults -currentHost read ... tapBehavior)`,
            # which aborts the set -e activation when that key is absent (live value is already Off).
            useTrackpadForScrolling = true;
          };
          # zoom.useKeyboardShortcutsToZoom lives in com.apple.universalaccess, which is TCC-protected:
          # writing it fails unless the terminal running the switch has Full Disk Access.

          appleIntelligenceAndSiri.siri.enable = false;

          # Dock layout and behaviour are not managed yet.
          desktopAndDock = {
            hotCorners = {
              topLeft.action = "-";
              topRight.action = "-";
              bottomLeft.action = "-";
              bottomRight = {
                action = "Quick Note";
                modifiers = {
                  command = false;
                  control = false;
                  option = false;
                  shift = false;
                };
              };
            };
            missionControl.shortcuts = {
              applicationWindows = "-";
              missionControl = "-";
              showDesktop = "-";
            };
          };

          general = {
            languageAndRegion = {
              preferredLanguages = ["en-US"];
              region = "en_US@rg=itzzzz";
            };
            sharing.mediaSharing.shareMediaWithGuests = false;
          };

          keyboard = {
            keyboardShortcuts.missionControl = {
              moveLeftASpace = true;
              moveRightASpace = true;
            };
            textInput = {
              addPeriodWithDoubleSpace = true;
              capitalizeWordsAutomatically = true;
              inputSources = ["com.apple.keylayout.USInternational-PC"];
            };
          };

          # Show24Hour stays in system.defaults.menuExtraClock: nix-plist-manager does not expose it.
          menuBar.clock = {
            showAmPm = true;
            showTheDayOfTheWeek = true;
          };

          privacyAndSecurity.appleAdvertising.personalizedAds = false;

          # searchResults intentionally omitted: Spotlight categories are still managed via
          # system.defaults.CustomUserPreferences."com.apple.Spotlight".orderedItems.

          trackpad = {
            pointAndClick.click = "Medium";
            scrollAndZoom = {
              rotate = true;
              zoomInOrOut = true;
            };
          };
        };
      };
    };
  };
}
