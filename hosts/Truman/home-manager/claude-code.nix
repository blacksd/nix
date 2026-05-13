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

      pagerduty_api_key = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "pagerduty/api_key";
      };

      slack_xoxc_token = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "slack/xoxc_token";
      };

      slack_xoxd_token = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "slack/xoxd_token";
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

    templates."pagerduty-env" = {
      content = ''
        export PAGERDUTY_USER_API_KEY="${config.sops.placeholder.pagerduty_api_key}"
      '';
    };

    templates."slack-env" = {
      content = ''
        export SLACK_MCP_XOXC_TOKEN="${config.sops.placeholder.slack_xoxc_token}"
        export SLACK_MCP_XOXD_TOKEN="${config.sops.placeholder.slack_xoxd_token}"
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
    settings = {
      autoMode = {
        environment = [
          "$defaults"
          "Organization: HiveMQ Cloud SRE team"
          "Source control: github.com/hivemq-cloud and github.com/hivemq (both private orgs)"
          "Cloud providers: AWS, GCP, Azure -- all three are used for apiary deployments"
          "Kubernetes: EKS, GKE, AKS clusters accessed via kubie/kubelogin/gcloud-auth and Tailscale"
          "GitOps: ArgoCD manages apiary deployments; changes go through Git repos"
          "Trusted internal domains: *.hmqc.dev, *.hmq.dev, *.hivemq.cloud"
          "Key internal services: Grafana at grafana.hmqc.dev (via MCP), PagerDuty at hivemq.eu.pagerduty.com (via MCP), Slack at dc-square.slack.com (via MCP), Linear at linear.app/hivemq (via MCP)"
          "Infrastructure-as-code: Terraform/Terragrunt for cloud infra, Nix/nix-darwin for local machine config"
          "Secrets management: sops with age/GPG keys for local machine config, 1Password CLI and AWS Secrets Manager (different instances) for customers"
          "Container runtime: Colima (local Docker alternative)"
          "Monorepo: hivemq-cloud/apiaries contains deployment configs for all apiaries"
        ];
        allow = [
          "$defaults"
          "Read-only kubectl operations (get, describe, logs, top) against any cluster context are allowed"
          "Running gh CLI for GitHub operations (PRs, issues, repo browsing) in hivemq-cloud org is allowed"
          "Running terraform plan (read-only) is allowed"
          "Running nix-darwin build and switch operations on the local machine is allowed"
          "Using all configured MCP servers (Grafana, PagerDuty, Slack, Linear, Kubernetes, ast-grep) is allowed"
          "Git operations on feature branches (commit, push, rebase) are allowed"
          "Running shellcheck, tflint, alejandra, pre-commit and other linters is allowed"
          "Docker/Colima operations for local development are allowed"
          "Reading and searching across any local repository is allowed"
        ];
        soft_deny = [
          "$defaults"
          "Do not run kubectl delete, patch, or edit against production clusters without explicit user instruction"
          "Do not run terraform apply or terragrunt apply without explicit user instruction"
          "Do not force-push to main, master, or release branches"
          "Do not modify ArgoCD application sync policies (enable/disable auto-sync) without explicit user instruction"
          "Do not send Slack messages or create PagerDuty incidents without explicit user instruction"
          "Do not create or close Linear issues without explicit user instruction"
          "Do not run helm install/upgrade/delete against any cluster without explicit user instruction"
          "Do not modify sops-encrypted secret files without explicit user instruction"
          "Do not run aws/gcloud/az commands that create, modify, or delete cloud resources without explicit user instruction"
          "Do not push Git tags or create GitHub releases without explicit user instruction"
        ];
        hard_deny = [
          "$defaults"
          "Never exfiltrate secrets, credentials, API keys, sops files, or .keys directory contents to external services"
          "Never expose customer hive credentials, MQTT credentials to third parties"
          "Never run kubectl exec or kubectl debug against production hive pods"
          "Never delete Kubernetes namespaces, PVCs, or CRDs in any environment"
          "Never run terraform destroy or terragrunt destroy"
          "Never modify or delete GitHub branch protection rules"
          "Never access or transmit SSH private keys outside the local machine"
        ];
      };
      # Override shared telemetry settings for work - enable OTEL telemetry
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

      # Miro collaboration MCP server
      miro = {
        type = "http";
        url = "https://mcp.miro.com";
      };

      # Context7 documentation MCP server (disabled)
      # context7 = {
      #   command = "${pkgs.bash}/bin/bash";
      #   args = [
      #     "-c"
      #     "source ${config.sops.templates.context7-env.path} && ${pkgs.nodejs_24}/bin/npx -y @upstash/context7-mcp --api-key \"$CONTEXT7_API_KEY\""
      #   ];
      # };

      # Grafana Cloud MCP server
      grafana = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.grafana-env.path} && ${pkgs-unstable.mcp-grafana}/bin/mcp-grafana"
        ];
      };

      # PagerDuty MCP server (self-hosted via uvx)
      pagerduty = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.pagerduty-env.path} && ${pkgs.uv}/bin/uvx pagerduty-mcp"
        ];
      };

      # Slack MCP server (xoxc/xoxd auth)
      slack = {
        command = "${pkgs.bash}/bin/bash";
        args = [
          "-c"
          "source ${config.sops.templates.slack-env.path} && ${pkgs.nodejs_24}/bin/npx -y slack-mcp-server@latest --transport stdio"
        ];
      };
    };
  };
}
