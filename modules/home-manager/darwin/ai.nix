{username, ...}: {
  # Darwin-specific AI configuration
  # Base AI config is in shared/ai.nix

  # Enable git and filesystem MCP servers (require overlay packages)
  programs.claude-code.mcp = {
    git.enable = true;
    filesystem = {
      enable = true;
      allowedPaths = ["/Users/${username}/Repositories"];
    };
  };
}
