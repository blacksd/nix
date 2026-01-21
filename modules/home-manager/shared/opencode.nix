{
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}: let
  # Get packages from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  programs.opencode = {
    enable = true;
    # Use opencode from nixpkgs-unstable
    package = pkgs-unstable.opencode;

    # Enable MCP integration (merges programs.mcp.servers into opencode config)
    enableMcpIntegration = true;

    # Settings configuration
    settings = {
      # Disable auto-update (managed by Nix)
      autoupdate = false;

      # Default model configuration
      model = "anthropic/claude-opus-4-5";
      small_model = "anthropic/claude-haiku-4-5";

      # Logging level
      logLevel = "INFO";

      # Agent configuration (uses top-level model by default)
    };

    # Global custom instructions for agents (written to AGENTS.md)
    rules = ''
      # Agent Guidelines

      ## Code Quality
      - Write clean, maintainable code
      - Follow existing project conventions
      - Add comments only where logic is non-obvious

      ## Communication
      - Be concise and direct
      - Avoid unnecessary compliments or affirmations
      - Ask clarifying questions when requirements are ambiguous
    '';
  };

  # MCP servers configuration (shared with other tools via programs.mcp)
  programs.mcp = {
    enable = true;
    servers = {
      ast-grep = {
        command = "${pkgs.uv}/bin/uvx";
        args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
      };
    };
  };
}
