# Claude Code module

Home-manager module that configures Claude Code on every host: package, `settings.json`, global `CLAUDE.md`, MCP servers, skills and the ccstatusline config. It wraps the upstream `programs.claude-code` options and adds one of its own.

## Layout

```
claude-code/
├── default.nix                  # the module
├── context/                     # markdown sections assembled into ~/.claude/CLAUDE.md
│   ├── principles.md
│   ├── style.md
│   └── tooling.md
├── settings/
│   └── ccstatusline.settings.json
└── README.md
```

Imported from `modules/home-manager/shared/default.nix`. Everything is guarded by `llm-agents` supporting the host system.

## Boundaries

Everything in this directory is consumed by this module only. Host modules (`hosts/<host>/home-manager/claude-code.nix`) never import files from here; they talk to it through `programs.claude-code.*` options, upstream or the ones defined below. If a host needs something new from the shared side, add an option.

## What goes where

| Concern | Mechanism | Writable at runtime |
|---|---|---|
| `~/.claude/settings.json` | `programs.claude-code.settings` (store symlink) | No: `/config`, `/plugin` and "always allow" rules do not persist. Change the Nix config instead. |
| `~/.claude/CLAUDE.md` | `programs.claude-code.context`, built from `context/*.md` plus `extraContext` | No |
| Plugins and upstream skills | `settings.enabledPlugins`; third-party marketplaces via `settings.extraKnownMarketplaces` (shared: context7, typesafe; Cydonia adds slack, code-review, ponytail) | Plugin code is fetched and updated by Claude Code itself |
| Private skills | a sops template rendered into `~/.claude/skills/<name>/SKILL.md` | No |
| MCP servers | `programs.claude-code.mcpServers`, shared here and per host | No |
| ccstatusline | activation script, writable copy | Yes: ccstatusline migrates the schema in place |

## Options added by this module

```nix
programs.claude-code.extraContext = lib.mkOption {
  type = lib.types.lines;
  default = "";
  description = "Host-specific sections appended to the global CLAUDE.md.";
};
```

## Host example: Cydonia

`hosts/Cydonia/home-manager/claude-code.nix` adds:

- `extraContext` with a short work-context section
- The `hivemq-cloud` skill: a sops template whose frontmatter is in Nix and whose body is the encrypted `secrets/hivemq_cloud.md.sops`, rendered by sops-nix straight into `~/.claude/skills/hivemq-cloud/SKILL.md`. The domain knowledge is loaded only when a task needs it.
- Ponytail via `enabledPlugins` and its marketplace
- Work MCP servers (Grafana, PagerDuty, Linear, Miro, Kubernetes) and OTEL telemetry

## Editing CLAUDE.md

Edit the files in `context/`, or add a new one and list it in `contextSections` in `default.nix`. Keep sections short: the whole file is loaded into every session.

## Editing the HiveMQ skill body

```shell
sops hosts/Cydonia/secrets/hivemq_cloud.md.sops   # opens the markdown in $EDITOR, re-encrypts on save
```

## Updating pins

- `ast-grep` MCP: bump the commit in the `git+https://...@<rev>` URL.
- Kubernetes MCP (Cydonia): bump the `kubernetes-mcp-server@<version>` npm spec.

Rebuild with `task switch` (or `make switch` on a fresh machine).
