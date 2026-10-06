{
  pkgs,
  lib,
  config,
  llm-agents,
  ...
}: let
  cfg = config.programs.claude-code;

  system = pkgs.stdenv.hostPlatform.system;
  supported = builtins.hasAttr system llm-agents.packages;
  llmPkgs =
    if supported
    then llm-agents.packages.${system}
    else null;

  # Global CLAUDE.md, assembled from the markdown sections in ./context.
  # Hosts append their own sections through `extraContext`.
  contextSections = ["principles.md" "style.md" "tooling.md"];
  baseContext = lib.concatMapStringsSep "\n" (f: lib.readFile (./context + "/${f}")) contextSections;
in {
  options.programs.claude-code.extraContext = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Host-specific sections appended to the global CLAUDE.md.";
  };

  config = lib.mkIf supported {
    programs.claude-code = {
      enable = true;
      package = llmPkgs.claude-code;

      context =
        "# Global instructions\n\n"
        + baseContext
        + lib.optionalString (cfg.extraContext != "") "\n${cfg.extraContext}";

      settings = {
        model = "claude-opus-5-5";
        effortLevel = "xhigh";
        permissions.defaultMode = "auto";
        outputStyle = "Concise";

        # Privacy
        env = {
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
          DISABLE_BUG_COMMAND = "1";
        };

        statusLine = {
          type = "command";
          command = "${llmPkgs.ccstatusline}/bin/ccstatusline";
        };

        # Opus 5.5 is not available with thinking mode switched off.
        alwaysThinkingEnabled = true;

        # Auto-copy selected text to clipboard ("copied N chars" hint)
        copyOnSelect = true;

        # Auto-scroll conversation view to bottom (fullscreen mode only)
        autoScrollEnabled = true;

        # Use the flicker-free fullscreen renderer (required for autoScrollEnabled)
        tui = "fullscreen";

        # Plugins available on every host. Claude Code fetches and updates the
        # plugin code itself from the marketplaces below.
        enabledPlugins = {
          "context7@claude-plugins-official" = true;
          # Its SessionStart hook mandates a multi-step process on every task,
          # which fights the Concise output style and Ponytail. Kept explicit
          # so a stale installed_plugins.json cannot re-enable it.
          "superpowers@claude-plugins-official" = false;
          # TypeSafe skill (System One models, Jev)
          "typesafe@typesafe-ai" = true;
        };

        extraKnownMarketplaces = {
          typesafe-ai = {
            source = {
              source = "github";
              repo = "typesafe-ai/skills";
            };
          };
        };
      };

      # MCP servers available on every host. Host-specific ones live in
      # hosts/<host>/home-manager/claude-code.nix.
      mcpServers = {
        ast-grep = {
          command = "${pkgs.uv}/bin/uvx";
          args = [
            "--from"
            "git+https://github.com/ast-grep/ast-grep-mcp@149e20d47bb7125fb0c1451feea2f48a98742034"
            "ast-grep-server"
          ];
        };
      };
    };

    # `node` on PATH for plugin hooks (Ponytail) and npx-based MCP servers.
    home.packages = [pkgs.nodejs_24];

    # ccstatusline configuration. Deployed as a writable copy rather than a
    # store symlink because ccstatusline >=2.2.29 rewrites this file to
    # migrate the schema on load.
    home.activation.ccstatuslineSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p "$HOME/.config/ccstatusline"
      if [ -L "$HOME/.config/ccstatusline/settings.json" ]; then
        run rm -f "$HOME/.config/ccstatusline/settings.json"
      fi
      run install -m 0644 ${./settings/ccstatusline.settings.json} \
        "$HOME/.config/ccstatusline/settings.json"
    '';
  };
}
