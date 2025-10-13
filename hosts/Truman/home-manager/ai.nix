{
  pkgs,
  nixpkgs-unstable,
  username,
  ...
}: let
  # Get claude-code from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  home.packages = with pkgs; [
    codex
  ];

  programs.claude-code = {
    enable = true;
    # Use claude-code from nixpkgs-unstable
    package = pkgs-unstable.claude-code;
    # mcp-servers comes from overlay in modules/base/nix-core.nix
    mcp = {
      git.enable = true;
      filesystem = {
        enable = true;
        allowedPaths = ["/Users/${username}/Repositories"];
      };
      # github = {
      #   enable = true;
      #   # tokenFilepath = "/path/to/github-token";
      # };
      servers = {
        businessmap-mcp = {
          type = "stdio";
          command = "${pkgs.nodejs_24}/bin/npx";
          args = ["-y" "@edicarlos.lds/businessmap-mcp"];
          env = {
            BUSINESSMAP_DEFAULT_WORKSPACE_ID = "1";
            # API_KEY_FILE = "/path/to/api-key";
          };
        };
      };
    };
  };
}
