{
  pkgs,
  lib,
  nixpkgs-unstable,
  username,
  config,
  ...
}: let
  # Get packages from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  # CLAUDE.md assembly from XML prompts
  claudeMdText = let
    promptsDir = ./claude/prompts;
    # TODO: Add hivemqCloudXmlPath support if needed via config.sops.secrets
    hivemqSection = ""; # if hivemqCloudXmlPath != null then "..." else "";
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
  home.packages = with pkgs-unstable; [
    codex
    yek
    ast-grep
  ];

  # Using built-in home-manager programs.claude-code
  programs.claude-code = {
    enable = true;
    # Use claude-code from nixpkgs-unstable
    package = pkgs-unstable.claude-code;

    # Settings configuration with privacy defaults and statusLine
    settings = {
      # Privacy settings
      env = {
        DISABLE_TELEMETRY = "1";
        DISABLE_ERROR_REPORTING = "1";
        DISABLE_BUG_COMMAND = "1";
      };

      # Enable ccstatusline for custom status display
      statusLine = {
        type = "command";
        command = "${pkgs.bun}/bin/bunx ccstatusline@latest";
      };

      # Disable always-on thinking mode by default
      alwaysThinkingEnabled = false;
    };

    # MCP servers using the built-in home-manager option
    # Note: mcpServers (not mcp) - this is the home-manager format
    mcpServers = {
      # Custom MCP servers (work everywhere)
      ast-grep = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
      };
      kubernetes-mcp-server = {
        command = "${pkgs.nodejs_24}/bin/npx";
        args = [
          "-y"
          "kubernetes-mcp-server@latest"
          "--disable-multi-cluster"
          "--read-only"
        ];
      };
      task-master-ai = {
        command = "${pkgs.nodejs_24}/bin/npx";
        args = [
          "-y"
          "--package=task-master-ai"
          "task-master-ai"
        ];
        env = {
          TASK_MASTER_TOOLS = "standard";
        };
      };
    };
  };

  # CLAUDE.md - assembled from XML prompts
  home.file.".claude/CLAUDE.md".text = claudeMdText;

  # ccstatusline configuration
  home.file.".config/ccstatusline/settings.json".source = ./claude/settings/ccstatusline.settings.json;
}
