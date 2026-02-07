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
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  # Using built-in home-manager programs.claude-code
  programs.claude-code = {
    enable = true;
    # Use claude-code from nixpkgs-unstable
    package = pkgs-unstable.claude-code;

    # Settings configuration with privacy defaults and statusLine
    settings = {
      # Model selection
      model = "claude-opus-4-6";

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

      # TODO: make some improvements on declarative plugin management
      # Reference implementation: https://github.com/JacobPEvans/nix/blob/main/modules/home-manager/ai-cli/claude/plugins.nix
      enabledPlugins = {
        "claude-mem@thedotmack" = true;
      };

      extraKnownMarketplaces = {
        thedotmack = {
          source = {
            source = "github";
            repo = "thedotmack/claude-mem";
          };
        };
      };
    };

    # MCP servers using the built-in home-manager option
    # Note: mcpServers (not mcp) - this is the home-manager format
    mcpServers = {
      # Custom MCP servers (work everywhere)
      ast-grep = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
      };
      kubernetes = {
        command = "${pkgs.nodejs_24}/bin/npx";
        args = [
          "-y"
          "kubernetes-mcp-server@latest"
          "--disable-multi-cluster"
          "--read-only"
        ];
      };
      taskmaster-ai = {
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
      filesystem = {
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
        ];
        command = "npx";
        type = "stdio";
      };
      # github = {
      #   type = "http";
      #   url = "https://api.githubcopilot.com/mcp/";
      # };
    };
  };

  # ccstatusline configuration (for Claude Code status display)
  home.file.".config/ccstatusline/settings.json".source = ./claude-code/settings/ccstatusline.settings.json;
}
