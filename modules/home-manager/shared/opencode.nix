{
  pkgs,
  lib,
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
    programs.opencode = {
      enable = !pkgs.stdenv.hostPlatform.isx86_64;
      package = llmPkgs.opencode;

      # Enable MCP integration (merges programs.mcp.servers into opencode config)
      enableMcpIntegration = true;

      # Settings configuration
      settings = {
        # Disable auto-update (managed by Nix)
        autoupdate = false;

        # Default model configuration
        model = "anthropic/claude-opus-4-5";
        small_model = "anthropic/claude-haiku-4-5";

        # Logging level
        logLevel = "INFO";

        # MCP servers for knowledge graph building and documentation access
        # Note: Opencode uses 'mcp' key directly in settings for remote servers
        mcp = {
          # Context7 - Documentation lookup for any library
          # Usage: append "use context7" to prompts for up-to-date docs
          context7 = {
            type = "remote";
            url = "https://mcp.context7.com/mcp";
            enabled = true;
          };

          # Sequential Thinking - Structured reasoning through thought sequences
          # Enables dynamic, reflective problem-solving
          sequential-thinking = {
            type = "local";
            command = ["${pkgs.nodejs_24}/bin/npx" "-y" "@anthropic/sequential-thinking-server"];
            enabled = true;
          };

          # Memory - Knowledge graph-based persistent memory
          # Stores entities, observations, and relationships across sessions
          memory = {
            type = "local";
            command = ["${pkgs.nodejs_24}/bin/npx" "-y" "@modelcontextprotocol/server-memory"];
            enabled = true;
          };

          # Filesystem - Read/write access to allowed directories
          filesystem = {
            type = "local";
            command = ["${pkgs.nodejs_24}/bin/npx" "-y" "@modelcontextprotocol/server-filesystem"];
            enabled = true;
          };
        };
      };

      # Global custom instructions for agents (written to AGENTS.md)
      # Renamed from `rules` to `context` in home-manager release-26.05.
      context = ''
        # Agent Guidelines

        ## Code Quality
        - Write clean, maintainable code
        - Follow existing project conventions
        - Add comments only where logic is non-obvious

        ## Communication
        - Be concise and direct
        - Avoid unnecessary compliments or affirmations
        - Ask clarifying questions when requirements are ambiguous

        ## Knowledge Graph Tools
        - Use Context7 (append "use context7") for up-to-date library documentation
        - Use Sequential Thinking for complex multi-step reasoning
        - Use Memory server to persist important entities and relationships
      '';
    };

    # MCP servers configuration (shared with other tools via programs.mcp)
    # These are stdio-based servers using the shared format
    programs.mcp = {
      enable = true;
      servers = {
        # AST-grep for structural code search
        ast-grep = {
          command = "${pkgs.uv}/bin/uvx";
          args = ["--from" "git+https://github.com/ast-grep/ast-grep-mcp" "ast-grep-server"];
        };
      };
    };
  }
