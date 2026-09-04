{
  pkgs,
  lib,
  username,
  config,
  llm-agents,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  supported = builtins.hasAttr system llm-agents.packages;
  llmPkgs =
    if supported
    then llm-agents.packages.${system}
    else null;
in
  lib.mkIf supported {
    # Using built-in home-manager programs.claude-code
    programs.claude-code = {
      enable = true;
      package = llmPkgs.claude-code;

      # Settings configuration with privacy defaults and statusLine
      settings = {
        # Model selection
        model = "claude-opus-4-8";

        # Reasoning effort for supported models
        effortLevel = "xhigh";

        # Default permission mode
        permissions.defaultMode = "auto";

        # Concise built-in output style
        outputStyle = "Concise";

        # Privacy settings
        env = {
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
          DISABLE_BUG_COMMAND = "1";
        };

        # Enable ccstatusline for custom status display
        statusLine = {
          type = "command";
          command = "${llmPkgs.ccstatusline}/bin/ccstatusline";
        };

        # Disable always-on thinking mode by default
        alwaysThinkingEnabled = false;

        # Auto-copy selected text to clipboard ("copied N chars" hint)
        copyOnSelect = true;

        # Auto-scroll conversation view to bottom (fullscreen mode only)
        autoScrollEnabled = true;

        # Use the flicker-free fullscreen renderer (required for autoScrollEnabled)
        tui = "fullscreen";

        # TODO: make some improvements on declarative plugin management
        # Reference implementation: https://github.com/JacobPEvans/nix/blob/main/modules/home-manager/ai-cli/claude/plugins.nix
        enabledPlugins = {
          "claude-mem@thedotmack" = false;
          "context7@claude-plugins-official" = true;
          "superpowers@claude-plugins-official" = true;
          "codex@openai-codex" = false;
        };

        extraKnownMarketplaces = {
          thedotmack = {
            source = {
              source = "github";
              repo = "thedotmack/claude-mem";
            };
          };
          openai-codex = {
            source = {
              source = "github";
              repo = "openai/codex-plugin-cc";
            };
          };
        };
      };

      # MCP servers using the built-in home-manager option
      # Note: mcpServers (not mcp) - this is the home-manager format
      mcpServers = {
        # Custom MCP servers (work everywhere)
        ast-grep = {
          command = "${pkgs.uv}/bin/uvx";
          args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
        };
        kubernetes = {
          command = "${pkgs.nodejs_24}/bin/npx";
          args = [
            "-y"
            "kubernetes-mcp-server@latest"
            "--disable-multi-cluster"
            "--read-only"
          ];
        };
        filesystem = {
          args = [
            "-y"
            "@modelcontextprotocol/server-filesystem"
          ];
          command = "npx";
          type = "stdio";
        };
        # github = {
        #   type = "http";
        #   url = "https://api.githubcopilot.com/mcp/";
        # };
      };
    };

    # ccstatusline configuration (for Claude Code status display).
    # Deployed as a writable copy rather than a store symlink because
    # ccstatusline >=2.2.29 rewrites this file to migrate the schema on load.
    home.activation.ccstatuslineSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/.config/ccstatusline"
      # Replace any prior Nix store symlink with a writable copy so
      # ccstatusline's on-load schema migration can rewrite it in place.
      if [ -L "$HOME/.config/ccstatusline/settings.json" ]; then
        run rm -f "$HOME/.config/ccstatusline/settings.json"
      fi
      run install -m 0644 ${./claude-code/settings/ccstatusline.settings.json} \
        "$HOME/.config/ccstatusline/settings.json"
    '';
  }
