# Nix Darwin

This is my `nix` setup, currently in use for three systems:

- `Truman` (from `The Expanse`'s [*Truman*-class dreadnought](https://expanse.fandom.com/wiki/Truman-class_dreadnought_(TV))) *(darwin, arm64)*
- `simpleton` *(darwin, Intel)*
- `rpi4` *(linux, arm64)*

## How to Use

### macOS (darwin) hosts

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

4. To preview changes and show diffs:

   ```shell
   darwin-rebuild build --flake ~/.config/nix-darwin#simpleton
   nvd diff /run/current-system ./result
   ```

### NixOS hosts (rpi4)

#### Initial provisioning

1. Flash the [official minimal NixOS aarch64 image](https://nixos.org/download/#nixos-iso) to the SD card
2. Boot the Pi, connect via SSH
3. Clone this repo and apply the configuration:

   ```shell
   sudo nixos-rebuild switch --flake .#rpi4
   ```

Alternatively, build a custom SD image with the full configuration baked in:

```shell
# Requires an aarch64-linux builder
nix build .#images.rpi4-sd
zstd -d result/sd-image/*.img.zst -o rpi4.img
# Flash to SD card (replace diskN with your device)
sudo dd if=rpi4.img of=/dev/diskN bs=4M status=progress
```

#### Ongoing updates

From your Mac, push config changes over SSH (builds on the Pi):

```shell
nixos-rebuild switch \
  --flake .#rpi4 \
  --target-host marco@rpi4.local \
  --use-remote-sudo
```

Or SSH into the Pi and rebuild locally:

```shell
sudo nixos-rebuild switch --flake .#rpi4
```

## Configuration Structure

The configuration is organized into a modular structure separating darwin-specific, nixos-specific, and shared configurations:

```bash
.
├── README.md
├── flake.nix
├── flake.lock
├── Taskfile.yml
├── hosts                          # per-host configurations
│   ├── Truman                     # macOS host
│   │   ├── default.nix            # main entrypoint for system-level customizations
│   │   ├── home.nix               # main entrypoint for user-level customizations
│   │   ├── apps.nix               # system-level app overrides
│   │   ├── ai.nix                 # AI/LLM configurations
│   │   ├── home-manager/          # host-specific home-manager configs
│   │   └── secrets/               # SOPS encrypted secrets
│   ├── simpleton                  # macOS host
│   │   ├── default.nix
│   │   ├── home.nix
│   │   ├── apps.nix
│   │   ├── aerospace.nix          # aerospace window manager config
│   │   ├── jankyborders.nix       # jankyborders config
│   │   └── home-manager/
│   └── rpi4                       # NixOS host (Raspberry Pi 4)
│       ├── default.nix
│       ├── home.nix
│       ├── hardware-configuration.nix
│       ├── sd-image.nix           # SD card image builder (flake output: images.rpi4-sd)
│       ├── disko-config.nix       # disk partitioning config
│       ├── networking.nix
│       └── users.nix
└── modules                        # reusable modules
    ├── home-manager               # user-level configurations
    │   ├── darwin/                # darwin-specific user configs
    │   │   ├── default.nix
    │   │   ├── core.nix
    │   │   ├── ai.nix
    │   │   ├── gpg.nix
    │   │   ├── k8s.nix
    │   │   └── claude/            # Claude AI configuration
    │   ├── nixos/                 # nixos-specific user configs
    │   │   └── default.nix
    │   └── shared/                # cross-platform user configs
    │       ├── default.nix
    │       ├── core.nix
    │       ├── git.nix
    │       ├── gpg.nix
    │       ├── shell.nix
    │       ├── ssh.nix
    │       ├── sops.nix
    │       ├── age.nix
    │       ├── nvim.nix
    │       ├── tmux.nix
    │       ├── kitty.nix
    │       ├── wezterm.nix
    │       └── configs/           # config files
    └── system                     # system-level configurations
        ├── darwin/                # darwin-specific system configs
        │   ├── default.nix
        │   ├── apps.nix
        │   ├── host-users.nix
        │   ├── nix-core.nix
        │   ├── system.nix
        │   └── configs/
        ├── nixos/                 # nixos-specific system configs
        │   └── default.nix
        └── shared/                # cross-platform system configs
            ├── default.nix
            ├── apps.nix
            ├── nix-settings.nix
            └── users.nix
```


## Credits

I'm freely taking inspiration from a few repositories that have extremely well-organized definitions:
* https://github.com/JacobPEvans/nix
