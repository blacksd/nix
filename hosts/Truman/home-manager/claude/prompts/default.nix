{ lib, config, ... }:

let
  claudeMd = import ./assemble-claude-md.nix { inherit lib; };
  cfg = config.programs.claude-code;
in
{
  options.programs.claude-code.assembleClaudeMd = lib.mkEnableOption "Assemble CLAUDE.md from XML prompts";

  config = lib.mkIf cfg.assembleClaudeMd {
    home.file.".claude/CLAUDE.md".text = claudeMd.text;
  };
}
