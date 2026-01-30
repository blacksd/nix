{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.claude-code;

  assembleClaudeMd = {hivemqCloudXmlPath ? null}: let
    promptsDir = ./prompts;

    hivemqSection =
      if hivemqCloudXmlPath != null
      then ''
        ---

        # HiveMQ Cloud Context

        @${hivemqCloudXmlPath}
      ''
      else "";
  in ''
    # CLAUDE.md - Assistant Configuration

    This document contains structured directives and context for Claude AI assistant.

    ---

    # Project Principles

    ${lib.readFile "${promptsDir}/project_principles.xml"}

    ---

    # Communication and Contribution Style

    ${lib.readFile "${promptsDir}/style.xml"}

    ---

    # Tooling Directives

    ${lib.readFile "${promptsDir}/tooling.xml"}
    ${hivemqSection}
  '';
in {
  # Claude Code configuration options
  options.programs.claude-code = {
    hivemqCloudXmlPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to HiveMQ Cloud XML context file (typically a decrypted sops secret)";
    };
  };

  config = {
    # Assemble and write CLAUDE.md
    home.file.".claude/CLAUDE.md".text = assembleClaudeMd {
      hivemqCloudXmlPath = cfg.hivemqCloudXmlPath;
    };

    # Add Node.js and Bun for claude-mem plugin support
    # Using nodejs_24 to match MCP server definitions
    home.packages = with pkgs; [
      nodejs_24
      bun
    ];
  };
}
