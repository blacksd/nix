{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.claude-code.settings;
in {
  options.programs.claude-code.settings = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.claude-code.enable;
      description = "Whether to manage Claude settings.json";
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
        DISABLE_BUG_COMMAND = "1";
      };
      description = "Environment variables for Claude Code";
    };

    alwaysThinkingEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable always-on thinking mode";
    };

    statusLine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable custom status line via ccstatusline";
      };

      command = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.bun}/bin/bunx ccstatusline@latest";
        description = "Command to execute for status line";
      };

      configPath = lib.mkOption {
        type = lib.types.path;
        default = ./ccstatusline.settings.json;
        description = "Path to ccstatusline settings";
      };
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional settings to merge into settings.json";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".claude/settings.json".text = builtins.toJSON (lib.mkMerge [
        {
          inherit (cfg) env alwaysThinkingEnabled;
        }
        (lib.optionalAttrs cfg.statusLine.enable {
          statusLine = {
            type = "command";
            command = cfg.statusLine.command;
          };
        })
        cfg.extraSettings
      ]);

      ".config/ccstatusline/settings.json" = lib.mkIf cfg.statusLine.enable {
        source = cfg.statusLine.configPath;
      };
    };
  };
}
