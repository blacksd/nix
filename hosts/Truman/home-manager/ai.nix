{
  pkgs,
  config,
  ...
}: {
  # Truman (work) host-specific secrets and MCP servers

  sops = {
    secrets = {
      # HiveMQ Cloud context for CLAUDE.md
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

      context7_api_key = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "context7/api_key";
      };
    };

    templates."businessmap-env" = {
      content = ''
        export BUSINESSMAP_API_URL="${config.sops.placeholder.businessmap_api_url}"
        export BUSINESSMAP_API_TOKEN="${config.sops.placeholder.businessmap_api_token}"
      '';
    };

    templates."context7-env" = {
      content = ''
        export CONTEXT7_API_KEY="${config.sops.placeholder.context7_api_key}"
      '';
    };
  };

  # TODO: add npx @toon-format/cli

  # Work-specific Claude Code configuration
  programs.claude-code = {
    # Enable HiveMQ Cloud context in CLAUDE.md
    hivemqCloudXmlPath = config.sops.secrets.hivemq_cloud_xml.path;

    # Work-specific MCP servers (extends shared/ai.nix configuration)
    mcpServers = {
      # Businessmap (Kanbanize) integration
      businessmap = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.businessmap-env.path} && ${pkgs.nodejs_24}/bin/npx -y @edicarlos.lds/businessmap-mcp"
        ];
        env = {
          BUSINESSMAP_DEFAULT_WORKSPACE_ID = "73";
        };
      };

      # Linear integration
      linear-server = {
        type = "http";
        url = "https://mcp.linear.app/mcp";
      };

      # Context7 documentation MCP server
      context7 = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.context7-env.path} && ${pkgs.nodejs_24}/bin/npx -y @upstash/context7-mcp --api-key \"$CONTEXT7_API_KEY\""
        ];
      };
    };
  };
}
