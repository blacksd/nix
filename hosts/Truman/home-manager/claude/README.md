# Claude Configuration

Structured configuration for Claude AI assistant, organized by component.

## Structure

```
claude/
├── prompts/              # CLAUDE.md assembly from XML sources
│   ├── project_principles.xml
│   ├── style.xml
│   ├── tooling.xml
│   ├── hivemq_cloud.xml
│   ├── assemble-claude-md.nix
│   └── default.nix
├── statusline/           # Claude Code statusline config
│   └── ccstatusline.settings.json
├── default.nix          # Top-level module
└── README.md
```

## Usage

Enable in Home Manager:

```nix
imports = [ ./hosts/Truman/home-manager/claude ];

programs.claude.enable = true;
```

This will:
- Assemble XML prompts into `~/.claude/CLAUDE.md`
- (Future) Configure Claude Code statusline

## Adding Prompt Sections

1. Create XML file in `prompts/`
2. Add to `prompts/assemble-claude-md.nix`
3. Rebuild Home Manager configuration
