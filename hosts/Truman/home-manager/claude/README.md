# Claude Configuration

Structured configuration for Claude AI assistant, organized by component.

## Structure

```
claude/
├── prompts/                      # CLAUDE.md assembly from XML sources
│   ├── project_principles.xml
│   ├── style.xml
│   ├── tooling.xml
│   ├── assemble-claude-md.nix
│   └── default.nix
├── settings/                     # settings.json and statusline config
│   ├── ccstatusline.settings.json
│   └── default.nix
├── default.nix                   # Top-level module
└── README.md
```

**Note:** `hivemq_cloud.xml` is stored encrypted in `../../secrets/` and imported via `@import` directive.

## Usage

Enable in Home Manager:

```nix
imports = [ ./hosts/Truman/home-manager/claude ];

programs.claude-code = {
  enable = true;

  # Assemble CLAUDE.md from XML prompts
  assembleClaudeMd = {
    enable = true;
    hivemqCloudXmlPath = config.sops.secrets.hivemq_cloud_xml.path;  # Optional
  };

  # Settings and statusline
  settings = {
    statusLine.enable = true;
    # Defaults to standard privacy settings and ccstatusline
  };
};
```

This will:
- Assemble XML prompts into `~/.claude/CLAUDE.md`
- Import HiveMQ Cloud context from decrypted sops secret (if configured)
- Generate `~/.claude/settings.json` with privacy defaults
- Configure ccstatusline for custom status display

## Configuration Options

### `assembleClaudeMd`
- `enable`: Whether to generate CLAUDE.md
- `hivemqCloudXmlPath`: Path to HiveMQ context XML (uses `@import` directive)

### `settings`
- `env`: Environment variables (defaults include DISABLE_TELEMETRY, etc.)
- `alwaysThinkingEnabled`: Enable always-on thinking mode (default: false)
- `statusLine.enable`: Enable ccstatusline integration
- `statusLine.command`: Command to run for status line
- `statusLine.configPath`: Path to ccstatusline settings
- `extraSettings`: Additional settings to merge into settings.json

## Adding Prompt Sections

1. Create XML file in `prompts/`
2. Add to `prompts/assemble-claude-md.nix`
3. Rebuild Home Manager configuration

## Customizing ccstatusline

Edit `settings/ccstatusline.settings.json` or use:
```bash
nix shell nixpkgs#bun --command bunx ccstatusline@latest
```
