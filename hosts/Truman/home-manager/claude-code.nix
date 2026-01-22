{
  pkgs,
  lib,
  nixpkgs-unstable,
  config,
  ...
}: let
  # Get packages from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
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

      grafana_url = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "grafana/url";
      };

      grafana_api_key = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "grafana/api_key";
      };

      otlp_auth_header = {
        sopsFile = ../secrets/claude-code.sops.yaml;
        key = "otlp/auth_header";
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

    templates."grafana-env" = {
      content = ''
        export GRAFANA_URL="${config.sops.placeholder.grafana_url}"
        export GRAFANA_API_KEY="${config.sops.placeholder.grafana_api_key}"
      '';
    };

    templates."otlp-headers-helper" = {
      mode = "0755";
      content = ''
        #!/bin/sh
        echo "{\"Authorization\": \"Basic ${config.sops.placeholder.otlp_auth_header}\"}"
      '';
    };
  };

  # TODO: add npx @toon-format/cli

  # Work-specific Claude Code configuration
  programs.claude-code = {
    # Override shared telemetry settings for work - enable OTEL telemetry
    settings = {
      env = {
        # Override DISABLE_TELEMETRY from shared config
        DISABLE_TELEMETRY = lib.mkForce "0";
        CLAUDE_CODE_ENABLE_TELEMETRY = "1";
        # OTEL configuration
        OTEL_METRICS_EXPORTER = "otlp";
        OTEL_EXPORTER_OTLP_PROTOCOL = "http/protobuf";
        OTEL_EXPORTER_OTLP_ENDPOINT = "http://alloy.hmqc.dev:4318";
        OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE = "cumulative";
      };
      # Helper script for OTEL auth header (secret injected via sops)
      otelHeadersHelper = config.sops.templates."otlp-headers-helper".path;
    };
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
      linear = {
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

      # Grafana Cloud MCP server
      grafana = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.grafana-env.path} && ${pkgs-unstable.mcp-grafana}/bin/mcp-grafana"
        ];
      };
    };
  };
}
