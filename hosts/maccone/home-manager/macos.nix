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
          accessibility = {
            audio.backgroundSounds = false;
            pointerControl = {
              ignoreBuiltInTrackpadWhenMouseOrWirelessTrackpadIsPresent = false;
              springLoading = true;
              springLoadingSpeed = 0.5;
              trackpadOptions = {
                # dragging = "Off" is omitted: upstream emits `tap=$(defaults -currentHost read ... tapBehavior)`,
                # which aborts the set -e activation when that key is absent (live value is already Off).
                useInertiaWhenScrolling = true;
                useTrackpadForScrolling = true;
              };
            };
            # zoom.useKeyboardShortcutsToZoom lives in com.apple.universalaccess, which is TCC-protected:
            # writing it fails unless the terminal running the switch has Full Disk Access.
          };

          appleIntelligenceAndSiri.siri.enable = false;

          desktopAndDock = {
            desktopAndStageManager = {
              clickWallpaperToRevealDesktop = "Always";
              showItems.inStageManager = false;
              showRecentAppsInStageManager = false;
              showWindowsFromAnApplication = "All at Once";
              stageManager = false;
            };
            dock = {
              automaticallyHideAndShowTheDock.enabled = true;
              magnification = {
                enabled = true;
                size = 71;
              };
              minimizeWindowsIntoApplicationIcon = false;
              showSuggestedAndRecentAppsInDock = false;
              size = 44;
            };
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
            widgets.showWidgets = {
              inStageManager = true;
              onDesktop = true;
            };
            windows = {
              dragWindowsToLeftOrRightEdgeOfScreenToTile = false;
              dragWindowsToMenuBarToFillScreen = false;
              holdOptionKeyWhileDraggingWindowsToTile = false;
            };
          };

          displays = {
            universalControl.allowPointerAndKeyboardToMoveBetweenNearbyDevices = false;
            whenConnectedToTv = "Ask What to Show";
          };

          general = {
            airDropAndContinuity.airDrop = "No One";
            languageAndRegion = {
              preferredLanguages = ["en-US"];
              region = "en_US@rg=itzzzz";
            };
            sharing.mediaSharing.shareMediaWithGuests = false;
          };

          keyboard = {
            keyboardShortcuts = {
              missionControl = {
                moveLeftASpace = true;
                moveRightASpace = true;
              };
              screenshots = {
                copyPictureOfScreenToTheClipboard = false;
                copyPictureOfSelectedAreaToTheClipboard = false;
                savePictureOfScreenAsAFile = false;
                savePictureOfSelectedAreaAsAFile = false;
                screenshotAndRecordingOptions = false;
              };
            };
            pressGlobeKeyTo = "Show Emoji & Symbols";
            textInput = {
              addPeriodWithDoubleSpace = true;
              capitalizeWordsAutomatically = true;
              inputSources = ["com.apple.keylayout.USInternational-PC"];
            };
          };

          # Show24Hour stays in system.defaults.menuExtraClock: nix-plist-manager does not expose it.
          menuBar = {
            clock = {
              showAmPm = true;
              showTheDayOfTheWeek = true;
            };
            textInput = false;
            timeMachine = false;
          };

          privacyAndSecurity.appleAdvertising.personalizedAds = false;

          sound.soundEffects.playFeedbackWhenVolumeIsChanged = true;

          # searchResults intentionally omitted: Spotlight categories are still managed via
          # system.defaults.CustomUserPreferences."com.apple.Spotlight".orderedItems.
          spotlight.showRelatedContent = true;

          trackpad = {
            moreGestures.notificationCenter = true;
            pointAndClick = {
              click = "Medium";
              forceClickAndHapticFeedback = true;
              lookUpAndDataDetectors = "Force Click with One Finger";
            };
            scrollAndZoom = {
              rotate = true;
              smartZoom = true;
              zoomInOrOut = true;
            };
          };
        };
      };
    };
  };
}
