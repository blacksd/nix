# Claude Customization Module

Reusable module for Claude AI assistant customizations.

## Structure

```
claude/
├── prompts/                      # XML prompt sources for CLAUDE.md
│   ├── project_principles.xml
│   ├── style.xml
│   ├── tooling.xml
│   └── assemble-claude-md.nix    # Assembly logic
├── settings/                     # Additional configuration files
│   └── ccstatusline.settings.json
├── default.nix                   # Module interface
└── README.md
```

## Current Features

### CLAUDE.md Assembly

Assembles `~/.claude/CLAUDE.md` from XML prompt files with optional HiveMQ Cloud context.

**Files involved:**
- `prompts/project_principles.xml` - Project principles and directives
- `prompts/style.xml` - Communication and contribution style
- `prompts/tooling.xml` - Tooling directives
- HiveMQ Cloud context (optional, from sops secret)

## Usage

The module is imported and used in `modules/home-manager/shared/ai.nix`:

```nix
{lib, config, ...}: let
  # Import claude module
  claudeModule = import ./claude {inherit lib;};

  # Check for optional HiveMQ Cloud secret (Truman host-specific)
  hivemqCloudXmlPath =
    if config.sops.secrets ? hivemq_cloud_xml
    then config.sops.secrets.hivemq_cloud_xml.path
    else null;

  # Generate CLAUDE.md text
  claudeMdText = claudeModule.assembleClaudeMd {
    inherit hivemqCloudXmlPath;
  };
in {
  # Write CLAUDE.md to home directory
  home.file.".claude/CLAUDE.md".text = claudeMdText;

  # Link ccstatusline config
  home.file.".config/ccstatusline/settings.json".source =
    ./claude/settings/ccstatusline.settings.json;
}
```

## Adding Prompt Sections

1. Create new XML file in `prompts/`
2. Add reference in `prompts/assemble-claude-md.nix`
3. Rebuild configuration: `darwin-rebuild switch`

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

## Future Extensibility

The module is designed to support additional customizations:

```nix
# In claude/default.nix (future)
{lib}: {
  assembleClaudeMd = { ... };  # Current

  # Future additions:
  commands = {
    myCommand = { ... };
  };

  skills = {
    mySkill = { ... };
  };

  hooks = {
    onPromptSubmit = { ... };
  };
}
```

## Customizing ccstatusline

Edit `settings/ccstatusline.settings.json` or regenerate interactively:

```bash
nix shell nixpkgs#bun --command bunx ccstatusline@latest
```

## Notes

- **Settings.json and MCP configuration** are managed by the built-in home-manager `programs.claude-code` module in `ai.nix`
- **HiveMQ Cloud context** is automatically included when the `hivemq_cloud_xml` sops secret exists (Truman host)
- The module is purely functional - no side effects or home-manager options
