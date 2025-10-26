{
  lib,
  config,
  ...
}: let
  cfg = config.programs.claude-code.assembleClaudeMd;

  claudeMd = import ./assemble-claude-md.nix {
    inherit lib;
    inherit (cfg) hivemqCloudXmlPath;
  };
in {
  options.programs.claude-code.assembleClaudeMd = {
    enable = lib.mkEnableOption "Assemble CLAUDE.md from XML prompts";

    hivemqCloudXmlPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to HiveMQ Cloud XML context file (typically a decrypted secret). Uses @import directive.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".claude/CLAUDE.md".text = claudeMd.text;
  };
}
