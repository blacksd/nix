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
in {
  # Note: ./claude module removed - using built-in home-manager programs.claude-code
  # If you need custom prompts/settings, configure them directly in programs.claude-code.settings

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

    # Settings and statusline configuration
    settings = {
      statusLine.enable = true;
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
}
