{
  services = {
    aerospace = {
      enable = false;
      settings = {
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        default-root-container-layout = "tiles";

        # Possible values: horizontal|vertical|auto
        # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
        #               tall monitor (anything higher than wide) gets vertical orientation
        default-root-container-orientation = "auto";
        accordion-padding = 60;
        key-mapping.preset = "qwerty";
        gaps = {
          inner.horizontal = 5;
          inner.vertical = 5;
          outer.left = 10;
          outer.bottom = 10;
          outer.top = 10;
          outer.right = 10;
        };
        mode.main.binding = {
          alt-comma = "layout accordion horizontal vertical";
          alt-slash = "layout tiles horizontal vertical";
          alt-r = "mode resize";
          alt-shift-semicolon = "mode service";
          alt-w = "mode windows";
        };
        mode.windows.binding = {
          esc = ["reload-config" "mode main"];
          alt-w = ["reload-config" "mode main"];
          # Change focus
          left = "focus left";
          down = "focus down";
          up = "focus up";
          right = "focus right";
          # Move a window
          alt-left = "move left";
          alt-down = "move down";
          alt-up = "move up";
          alt-right = "move right";
          # Merge
          alt-shift-left = "join-with left";
          alt-shift-down = "join-with down";
          alt-shift-up = "join-with up";
          alt-shift-right = "join-with right";
        };
        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"]; # reset layout
          f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout;
          backspace = ["close-all-windows-but-current" "mode main"];
          # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
          #s = ["layout sticky tiling" "mode main"];
        };
        mode.resize.binding = {
          esc = ["reload-config" "mode main"];
          alt-r = ["reload-config" "mode main"];
          alt-keypadMinus = "resize smart -50";
          alt-keypadPlus = "resize smart +50";
        };
        on-window-detected = [
          {
            check-further-callbacks = false;
            "if" = {
              app-name-regex-substring = "finder";
              during-aerospace-startup = true;
            };
            run = ["layout floating"];
          }
          {
            "if" = {
              # app-id = "Another.Cool.App";
              # window-title-regex-substring = "Title";
              app-name-regex-substring = "Ferdium";
              during-aerospace-startup = true;
              workspace = "messages";
            };
            run = ["layout floating"];
          }
        ];
      };
    };
  };
}
