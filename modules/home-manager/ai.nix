{
  pkgs,
  nixpkgs-unstable,
  username,
  config,
  ...
}: let
  # Get claude-code from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
  imports = [
    ./claude
  ];

  home.packages = with pkgs-unstable; [
    codex
    yek
    ast-grep
  ];

  # Using programs.claude-code from roman/claude-code for personal setup
  programs.claude-code = {
    enable = true;
    # Use claude-code from nixpkgs-unstable
    package = pkgs-unstable.claude-code;

    # Settings and statusline configuration
    settings = {
      statusLine.enable = true;
    };

    # mcp-servers packages come from mcp-servers-nix overlay in modules/base/nix-core.nix
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
        ast-grep = {
          type = "stdio";
          command = "${pkgs.uv}/bin/uvx";
          args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
        };
        kubernetes-mcp-server = {
          type = "stdio";
          command = "${pkgs.nodejs_24}/bin/npx";
          args = [
            "-y"
            "kubernetes-mcp-server@latest"
            "--disable-multi-cluster"
            "--read-only"
          ];
        };
      };
    };
  };
}
