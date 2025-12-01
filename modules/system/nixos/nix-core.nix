{
  claude-code,
  ...
}: {
  # Allow unfree packages (VSCode, etc.)
  nixpkgs.config.allowUnfree = true;

  # Add claude-code overlay for mcp-servers support
  nixpkgs.overlays = [
    claude-code.overlays.default
  ];
}
