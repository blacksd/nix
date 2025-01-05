# Nix Darwin 

This is my `nix` setup, currently in use for two systems:

- `Truman` (from `The Expanse`'s [*Truman*-class dreadnought](https://expanse.fandom.com/wiki/Truman-class_dreadnought_(TV)))
- `simpleton`

## How to Use (existing system)

0. Install `git`, `nix` and `Homebrew`, and log in with your Apple ID
1. Clone this repo in a local directory, i.e. `~/.config/nix-darwin`
2. Install `nix-darwin` and activate it:

   ```shell
   nix run nix-darwin -- switch --flake ~/.config/nix-darwin#simpleton
   ```

3. Any time you need to activate a new configuration:

    ```shell
   darwin-rebuild switch --flake ~/.config/nix-darwin#simpleton
   ```

## Configuration Structure

Your current nix-darwin configuration's structure should be as follows:

```bash
❯ tree .
.
├── README.md
├── flake.nix
├── hosts
│   └── Truman
│       ├── home-manager
│       │   ├── shell-functions
│       │   │   ├── aws.zsh
│       │   │   └── vscode.zsh
│       │   ├── core.nix        # <-- home-manager level overrides
│       │   ├── shell.nix
│       │   ├── ssh.nix
│       │   └── tools.nix
│       ├── default.nix         # <-- main entrypoint for system-level customizations
│       ├── apps.nix            # <-- system-level overrides
│       └── home-manager.nix    # <-- main entrypoint for user-level customizations
└── modules
    ├── base
    │   ├── configs
    │   │   └── eu.exelban.Stats.plist.json
    │   ├── default.nix
    │   ├── apps.nix
    │   ├── host-users.nix
    │   ├── nix-core.nix
    │   └── system.nix
    └── home-manager
        ├── configs
        │   └── iTerm2-nix-profiles.plist.json
        ├── default.nix
        ├── core.nix
        ├── git.nix
        ├── gpg.nix
        └── shell.nix
```
