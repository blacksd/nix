# Nix Darwin

This is my `nix` setup, currently in use for these systems:

- `Cydonia` (from `The Expanse`'s [MCRD *Cydonia*](https://expanse.fandom.com/wiki/Cydonia)) *(darwin, arm64)*
- `Truman` (from `The Expanse`'s [*Truman*-class dreadnought](https://expanse.fandom.com/wiki/Truman-class_dreadnought_(TV))) *(darwin, arm64)*: being replaced by `Cydonia`, shares its host config until decommissioned
- `rpi4` *(linux, arm64)*
- `minipc` *(linux, x86_64)*
- `rpi1` *(linux, armv6l)*

## How to Use

### macOS (darwin) hosts

#### Fresh install

1. In Setup Assistant, set the account short name to the `username` in `flake.nix` (`marco.bulgarini`, not the suggested `marcobulgarini`), skip Migration Assistant, and sign in to the App Store (`mas` apps need it)
2. Install the prerequisites (the `task prerequisites` equivalent, since `task` isn't installed yet):

   ```shell
   xcode-select --install
   # NixOS community installer: nix-darwin manages upstream Nix, Determinate Nix would need nix.enable = false
   curl --proto '=https' --tlsv1.2 -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Clone over HTTPS (the GitHub SSH key is a sops secret) into `~/.config/nix-darwin`, the path `modules/home-manager/shared/age.nix` expects:

   ```shell
   git clone https://github.com/blacksd/nix ~/.config/nix-darwin
   ```

4. Create the host's age identity on the YubiKey, plus a paper-only backup key:

   ```shell
   nix shell nixpkgs#age nixpkgs#age-plugin-yubikey
   # pin-policy must be "never": sops-nix decrypts from a launchd agent with no TTY to prompt for a PIN
   age-plugin-yubikey --generate --name Cydonia --pin-policy never --touch-policy never
   age-plugin-yubikey --identity > ~/.config/nix-darwin/hosts/Cydonia/.keys/keys.txt  # identity stub, not a secret
   age-plugin-yubikey --list   # public key of the YubiKey identity

   age-keygen      # copy the AGE-SECRET-KEY-1... line to paper and note the public key; never save it to disk
   age-keygen -y   # type the paper copy back in, then Ctrl-D: it must print the same public key
   ```

   Close the terminal window afterwards so the backup key doesn't survive in the scrollback. `--touch-policy cached` also works, but then the YubiKey has to be touched at every login and switch with no on-screen prompt.

5. On a host that can already decrypt the secrets and has `age-plugin-yubikey` installed (required to encrypt for a YubiKey recipient): add both public keys to `.sops.yaml` (in the `hosts/Cydonia` and `modules/home-manager/shared` rules), run `task sops_updatekeys`, commit and push. Then `git pull` on the new host.
6. Bring over the state Nix doesn't manage: GPG keys (commits are signed by default), SSH keys that aren't sops secrets, `~/.aws/config`
7. Move aside the `/etc` files nix-darwin refuses to overwrite (it lists any others), then run the first activation with the YubiKey plugged in:

   ```shell
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   sudo nix run nix-darwin/nix-darwin-26.05 -- switch --flake ~/.config/nix-darwin#Cydonia --option accept-flake-config true
   git -C ~/.config/nix-darwin remote set-url origin git@github.com:blacksd/nix.git
   ```

#### Day to day

`task switch` and `task diff` pick the flake output matching the machine's hostname. The YubiKey must be plugged in at login and on every switch, or sops-nix can't decrypt the secrets; after plugging it in, `launchctl kickstart -k gui/$(id -u)/org.nix-community.home.sops-nix` retries.

#### Retiring Truman

Drop the `Truman` entries from `flake.nix`, the `Truman` mapping in the `plist-drift` task and the Launchpad Dock entry in `hosts/Cydonia/macos.nix`, remove `Truman` and `Truman_backup` from `.sops.yaml`, then run `task sops_updatekeys`.

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
│   ├── Cydonia                    # macOS host (also used by Truman until it is decommissioned)
│   │   ├── default.nix            # main entrypoint for system-level customizations
│   │   ├── home.nix               # main entrypoint for user-level customizations
│   │   ├── apps.nix               # system-level app overrides
│   │   ├── ai.nix                 # AI/LLM configurations
│   │   ├── home-manager/          # host-specific home-manager configs
│   │   ├── secrets/               # SOPS encrypted secrets
│   │   └── .keys/                 # age identity (gitignored; a YubiKey identity stub on Cydonia)
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
