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
  # Cydonia (work) host-specific secrets, context, plugins and MCP servers

  sops = {
    secrets = {
      # HiveMQ Cloud domain knowledge (markdown), the body of the skill below
      hivemq_cloud_md = {
        sopsFile = ../secrets/hivemq_cloud.md.sops;
        format = "binary";
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

      otlp_auth_header = {
        sopsFile = ../secrets/claude-code.sops.yaml;
        key = "otlp/auth_header";
      };
    };

    # The HiveMQ Cloud context is a skill rather than a CLAUDE.md section so it
    # only enters the context window when a task is actually about HiveMQ
    # Cloud. The frontmatter description is what triggers it; the body is the
    # encrypted markdown. sops-nix renders the file straight into the skills
    # directory, next to the store-managed skills.
    templates."hivemq-cloud-skill" = {
      path = "${config.home.homeDirectory}/.claude/skills/hivemq-cloud/SKILL.md";
      content = ''
        ---
        name: hivemq-cloud
        description: HiveMQ Cloud domain knowledge - hive and apiary terminology, deployment tiers (starter, professional, enterprise, serverless), Control Center and MQTT URL patterns, the apiaries monorepo and legacy deployment repositories, documentation links. Use when a task mentions hives, apiaries, hiveids, cc- URLs, hivemq.cloud hostnames, ArgoCD apiary deployments, or the hivemq-cloud GitHub organization.
        ---

        ${config.sops.placeholder.hivemq_cloud_md}
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
    extraContext = ''
      ## Work context

      - The user is an SRE on the HiveMQ Cloud team. Assume fluency in Kubernetes, Terraform, ArgoCD and Nix; skip the basics.
      - Source lives on GitHub under the private `hivemq-cloud` and `hivemq` organizations. Always use `gh`.
      - For HiveMQ Cloud terminology, deployment tiers, URL patterns and repository layout, load the `hivemq-cloud` skill before acting.
    '';

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
      enabledPlugins = {
        "slack@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        # Lazy-senior-dev mode: smallest working change, stdlib first.
        # Its hooks need `node` on PATH (shared module provides it).
        "ponytail@ponytail" = true;
      };
      extraKnownMarketplaces = {
        ponytail = {
          source = {
            source = "github";
            repo = "DietrichGebert/ponytail";
          };
        };
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

    # Work-specific MCP servers (extends the shared set in modules/home-manager/shared/claude-code)
    mcpServers = {
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

      # Kubernetes MCP server, read-only, against the current kube context.
      # Pinned: `@latest` was resolved on every start.
      kubernetes = {
        command = "${pkgs.nodejs_24}/bin/npx";
        args = [
          "-y"
          "kubernetes-mcp-server@0.0.67"
          "--disable-multi-cluster"
          "--read-only"
        ];
      };
    };
  };
}
