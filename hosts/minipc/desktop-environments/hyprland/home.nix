{
  pkgs,
  config,
  lib,
  ...
}: {
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      # Monitor configuration
      # Main 4K display with 125% scaling
      monitor = [
        "DP-1,preferred,auto,1.25"
        "HDMI-A-1,disable"
      ];

      # Execute at launch
      exec-once = [
        "swww-daemon"
        "hyprpanel"
        "~/.local/bin/generate-hypr-keybindings.sh"
        "gnome-keyring-daemon --start --components=secrets"
      ];

      # XWayland settings
      xwayland = {
        force_zero_scaling = true;
      };

      # Environment variables for Wayland native apps
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "NIXOS_OZONE_WL,1"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        kb_variant = "intl";
        kb_options = "compose:ralt";
        follow_mouse = 1;
        float_switch_override_focus = 2;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout configuration
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Miscellaneous
      misc = {
        force_default_wallpaper = 0;
        disable_autoreload = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      # Keybindings
      "$mod" = "SUPER";

      bind = [
        # Application shortcuts
        "$mod, Return, exec, wezterm"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating,"
        "$mod, R, exec, pkill rofi || rofi -show drun"
        "$mod, D, exec, pkill rofi || rofi -show run"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Waybar - status bar (disabled in favor of hyprpanel)
  programs.waybar = {
    enable = false;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;

        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "tray"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
        };

        memory = {
          format = " {}%";
        };


        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background: transparent;
      }

      #workspaces button.active {
        background: rgba(137, 180, 250, 0.3);
        border-bottom: 2px solid #89b4fa;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.2);
      }

      #window,
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 0 4px;
        background: rgba(49, 50, 68, 0.5);
        border-radius: 8px;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #f9e2af;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
      }
    '';
  };

  # Notification daemon (disabled in favor of hyprpanel's built-in notifications)
  services.mako = {
    enable = false;
    settings = {
      default-timeout = 5000;
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 8;
      border-size = 2;
      width = 300;
      height = 100;
      padding = "10";
      margin = "10";
    };
  };

  # HyprPanel - status bar and notification center
  programs.hyprpanel = {
    enable = true;
    systemd.enable = false;  # Use exec-once instead due to timing issues

    settings = {
      theme.font = {
        name = "JetBrainsMono Nerd Font";
        size = "12px";
      };
    };
  };

  # Generate keybindings reference on startup
  home.file.".local/bin/generate-hypr-keybindings.sh" = {
    text = ''
      #!/usr/bin/env bash

      KEYBINDINGS_FILE="$HOME/Documents/hyprland-keybindings.md"
      mkdir -p "$(dirname "$KEYBINDINGS_FILE")"

      cat > "$KEYBINDINGS_FILE" << 'EOF'
      # Hyprland Keybindings Reference

      Generated: $(date)

      ## Window Management

      - **Super + Return** - Open terminal (Wezterm)
      - **Super + Q** - Close active window
      - **Super + M** - Exit Hyprland
      - **Super + V** - Toggle floating mode
      - **Super + P** - Toggle pseudo-tiling
      - **Super + J** - Toggle split direction

      ## Application Launchers

      - **Super + R** - Application launcher (Rofi - drun mode)
      - **Super + D** - Command runner (Rofi - run mode)
      - **Super + E** - File manager (Nautilus)

      ## Focus Management

      - **Super + Left** - Move focus left
      - **Super + Right** - Move focus right
      - **Super + Up** - Move focus up
      - **Super + Down** - Move focus down

      ## Workspace Switching

      - **Super + 1-9** - Switch to workspace 1-9
      - **Super + 0** - Switch to workspace 10
      - **Super + Mouse Wheel Up** - Previous workspace
      - **Super + Mouse Wheel Down** - Next workspace

      ## Window Moving

      - **Super + Shift + 1-9** - Move window to workspace 1-9
      - **Super + Shift + 0** - Move window to workspace 10

      ## Mouse Bindings

      - **Super + Left Click + Drag** - Move window
      - **Super + Right Click + Drag** - Resize window

      ## Screenshots

      - **Print Screen** - Select area to screenshot (copies to clipboard)

      ## Notes

      - Keybindings file location: \`$KEYBINDINGS_FILE\`
      - To regenerate this file, restart Hyprland or run: \`~/.local/bin/generate-hypr-keybindings.sh\`
      EOF

      echo "Keybindings reference generated at: $KEYBINDINGS_FILE"
    '';
    executable = true;
  };

  # Additional packages for Hyprland
  home.packages = with pkgs; [
    # GTK theme configuration utility
    nwg-look
    gnome-themes-extra
    adwaita-icon-theme

    # File manager
    nautilus

    # Image viewer
    imv

    # Video player
    mpv

    # PDF viewer
    zathura

    # Audio control
    pavucontrol

    # Network manager applet
    networkmanagerapplet
  ];
}
