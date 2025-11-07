{
  pkgs,
  config,
  ...
}: {
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

  programs.claude-code = {
    # Assemble CLAUDE.md from XML prompts
    assembleClaudeMd = {
      enable = true;
      hivemqCloudXmlPath = config.sops.secrets.hivemq_cloud_xml.path;
    };

    mcp = {
      servers = {
        businessmap = {
          type = "stdio";
          command = "${pkgs.bash}/bin/bash";
          args = ["-c" "source ${config.sops.templates.businessmap-env.path} && ${pkgs.nodejs_24}/bin/npx -y @edicarlos.lds/businessmap-mcp"];
          env = {
            BUSINESSMAP_DEFAULT_WORKSPACE_ID = "73";
          };
        };
        linear = {
          type = "sse";
          url = "https://mcp.linear.app/sse";
        };
      };
    };
  };
}
