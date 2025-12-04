# Claude Code Customization Module

Home-manager module for Claude Code CLAUDE.md assembly and customizations.

## Structure

```
claude-code/
├── prompts/                      # XML prompt sources for CLAUDE.md
│   ├── project_principles.xml
│   ├── style.xml
│   ├── tooling.xml
│   └── assemble-claude-md.nix    # Assembly logic
├── settings/                     # Configuration files (referenced by ai.nix)
│   └── ccstatusline.settings.json
├── default.nix                   # Home-manager module
└── README.md
```

## What This Module Does

This is a **home-manager module** that:
- Defines `programs.claude-code.hivemqCloudXmlPath` option
- Assembles `~/.claude/CLAUDE.md` from XML prompt files
- Optionally includes HiveMQ Cloud context (via sops secret)

## Module Architecture

```nix
# Imported automatically in modules/home-manager/shared/default.nix
imports = [
  ./claude-code  # This module
  ...
];
```

### Option Definition

```nix
options.programs.claude-code.hivemqCloudXmlPath = lib.mkOption {
  type = lib.types.nullOr lib.types.path;
  default = null;
  description = "Path to HiveMQ Cloud XML context file";
};
```

### Configuration

```nix
config = {
  # Assembles and writes CLAUDE.md
  home.file.".claude/CLAUDE.md".text = assembleClaudeMd {
    hivemqCloudXmlPath = cfg.hivemqCloudXmlPath;
  };
};
```

## Usage

### Default (No HiveMQ Cloud Context)

The module is automatically imported and works with default settings on all hosts.

### Host-Specific Override (Truman)

```nix
# hosts/Truman/home-manager/ai.nix
programs.claude-code.hivemqCloudXmlPath = config.sops.secrets.hivemq_cloud_xml.path;
```

This enables the HiveMQ Cloud context section in CLAUDE.md for the Truman (work) host.

## CLAUDE.md Content

The assembled CLAUDE.md includes:

1. **Project Principles** (`prompts/project_principles.xml`)
2. **Communication and Contribution Style** (`prompts/style.xml`)
3. **Tooling Directives** (`prompts/tooling.xml`)
4. **HiveMQ Cloud Context** (optional, if `hivemqCloudXmlPath` is set)

Example output:
```markdown
# CLAUDE.md - Assistant Configuration

This document contains structured directives and context for Claude AI assistant.

---

# Project Principles

<project_principles>...</project_principles>

---

# Communication and Contribution Style

<style>...</style>

---

# Tooling Directives

<tooling>...</tooling>

---

# HiveMQ Cloud Context

@/run/user/501/secrets/hivemq_cloud_xml
```

## Adding Prompt Sections

1. Create new XML file in `prompts/`
2. Update `prompts/assemble-claude-md.nix` to include it
3. Rebuild: `task switch`

Example:
```xml
<!-- prompts/my_context.xml -->
<context>
  <description>Custom context for Claude</description>
  <directives>
    <directive>Follow specific guidelines...</directive>
  </directives>
</context>
```

Then add to `assembleClaudeMd` function in `default.nix`.

## Related Configuration

### Claude Code Settings & MCP (ai.nix)

Claude Code runtime configuration is in `modules/home-manager/shared/ai.nix`:
- `programs.claude-code.settings` - Privacy settings, statusLine
- `programs.claude-code.mcpServers` - MCP server definitions
- ccstatusline settings link

### Host-Specific MCP (hosts/Truman/home-manager/ai.nix)

Work-specific MCP servers:
- `businessmap` - Kanbanize integration
- `linear` - Linear integration

## Future Extensibility

The module can be extended with:

```nix
# In claude-code/default.nix (future)
options.programs.claude-code = {
  hivemqCloudXmlPath = ...;  # Current

  # Future additions:
  commands = mkOption { ... };
  skills = mkOption { ... };
  hooks = mkOption { ... };
};
```

## Notes

- **Scope**: This module only handles CLAUDE.md assembly
- **Settings**: Claude Code settings.json and MCP configuration are in `ai.nix`
- **ccstatusline**: Config file stored here but linked from `ai.nix`
- **HiveMQ Context**: Automatically included when secret exists (Truman only)
