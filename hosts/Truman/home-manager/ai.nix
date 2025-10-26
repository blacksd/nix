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
  # Alternative approach using mcp-servers-nix for project-specific .mcp.json
  # This generates a .mcp.json file suitable for project directories. Variable expansion is supported.
  # INFO: https://docs.claude.com/en/docs/claude-code/mcp#project-scope
  # mcpConfig = mcp-servers-nix.lib.mkConfig pkgs {
  #   flavor = "claude";
  #   format = "json";
  #   fileName = ".mcp.json";
  #   programs = {
  #     git.enable = true;
  #     filesystem = {
  #       enable = true;
  #       args = ["/Users/${username}/Repositories"];
  #     };
  #     github = {
  #       enable = true;
  #       passwordCommand = {
  #         GITHUB_PERSONAL_ACCESS_TOKEN = ["gh" "auth" "token"];
  #       };
  #     };
  #   };
  #   # Custom MCP servers not in mcp-servers-nix
  #   settings.servers = {
  #     businessmap-mcp = {
  #       type = "stdio";
  #       command = "${pkgs.nodejs_24}/bin/npx";
  #       args = ["-y" "@edicarlos.lds/businessmap-mcp"];
  #       env = {
  #         BUSINESSMAP_DEFAULT_WORKSPACE_ID = "1";
  #       };
  #     };
  #   };
  # };
  # And then we link the .mcp.json to a project directory
  # home.file."Repositories/project/.mcp.json".source = mcpConfig;
in {
  imports = [
    ./claude
  ];

  home.packages = with pkgs-unstable; [
    codex
    yek
    ast-grep
  ];

  # Decrypt the files and create a template with the env var exports
  sops = {
    secrets = {
      hivemq_cloud_xml = {
        sopsFile = ../secrets/hivemq_cloud.xml.sops;
        format = "binary";
      };

      businessmap_api_token = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/api_token";
      };

      businessmap_api_url = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/api_url";
      };
    };

    templates."businessmap-env" = {
      content = ''
        export BUSINESSMAP_API_URL="${config.sops.placeholder.businessmap_api_url}"
        export BUSINESSMAP_API_TOKEN="${config.sops.placeholder.businessmap_api_token}"
      '';
    };
  };

  # Using programs.claude-code from roman/claude-code for personal setup
  programs.claude-code = {
    enable = true;
    # Use claude-code from nixpkgs-unstable
    package = pkgs-unstable.claude-code;

    # Assemble CLAUDE.md from XML prompts
    assembleClaudeMd = {
      enable = true;
      hivemqCloudXmlPath = config.sops.secrets.hivemq_cloud_xml.path;
    };

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
        businessmap = {
          type = "stdio";
          command = "${pkgs.bash}/bin/bash";
          args = ["-c" "source ${config.sops.templates.businessmap-env.path} && ${pkgs.nodejs_24}/bin/npx -y @edicarlos.lds/businessmap-mcp"];
          env = {
            BUSINESSMAP_DEFAULT_WORKSPACE_ID = "73";
            BUSINESSMAP_READ_ONLY_MODE = "true";
          };
        };
        ast-grep = {
          type = "stdio";
          command = "${pkgs.uv}/bin/uvx";
          args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
        };
        linear = {
          type = "sse";
          url = "https://mcp.linear.app/sse";
          # INFO: not needed, just the URL
          # command = "${pkgs.nodejs_24}/bin/npx";
          # args = ["-y" "mcp-remote" "https://mcp.linear.app/sse"];
        };
      };
    };
  };
}
