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
2. Install the Command Line Tools (git and make), clone over HTTPS (the GitHub SSH key is a sops secret) into `~/.config/nix-darwin`, the path `modules/home-manager/shared/age.nix` expects, and bootstrap:

   ```shell
   xcode-select --install
   git clone https://github.com/blacksd/nix ~/.config/nix-darwin && cd ~/.config/nix-darwin
   make bootstrap HOST=Cydonia
   ```

   `make bootstrap` installs Nix (NixOS community installer) and Homebrew, sets the hostname, moves the installer's `/etc/nix/nix.conf` aside, and runs the first activation with the nix-darwin release pinned in `flake.lock`. Each step is also a target of its own (`make help`). If nix-darwin lists other `/etc` files it refuses to overwrite, rename them to `<file>.before-nix-darwin` and run `make switch`.

3. Secrets: in Terminal on the Mac itself (Secure Enclave keys can't be created over SSH), run `make age-key` to create the host key and print its public key, then create a paper backup key (see [Host key in the Secure Enclave](#host-key-in-the-secure-enclave)). On a host that can already decrypt the secrets, add both public keys and re-encrypt (see [Adding or removing a host](#adding-or-removing-a-host)), then `git pull && task switch` here.
4. Finish the machine:
   - Give Full Disk Access (System Settings → Privacy & Security) to the terminal you run switches from: nix-plist-manager writes the Wi-Fi settings under `/Library/Preferences/SystemConfiguration`, which recent macOS releases protect
   - Switch the remote to SSH: `git remote set-url origin git@github.com:blacksd/nix.git`
   - Link the GPG keys on the YubiKey (commits are signed by default):

     ```shell
     curl -s https://github.com/blacksd.gpg | gpg --import
     gpg --card-status   # links the subkeys to the card: gpg -K should show sec# and ssb>
     echo '3CF3DF3A9BC24FE443B43A19DE488690EDAE6AE6:6:' | gpg --import-ownertrust
     ```

   - Log in to the CLIs and apps: `gh`, 1Password, Tailscale, the cloud CLIs, Claude Code

#### Moving from another Mac

Skip Migration Assistant: it copies home-directory links that point into `/nix/store`, but not the store itself. Bring over only what Nix doesn't manage:

- Secrets: SSH keys that aren't sops secrets, `~/.netrc`, the aws-vault keychain, `~/.aws/config`, and GPG keys that aren't on a YubiKey. Encrypt them for the new host's Secure Enclave key, so only it can decrypt the bundle:

  ```shell
  # old host, from $HOME, with age-plugin-se available
  tar czf - <paths> | age -r age1se1... -o state.tar.gz.age
  # new host, from $HOME
  age -d -i ~/.config/nix-darwin/hosts/Cydonia/.keys/keys.txt state.tar.gz.age | tar xzf -
  ```

- Data: `~/Repositories` as a whole (local branches, stashes and ignored files don't survive a re-clone), documents, Claude Code memory. Temporarily enable Remote Login on the new host and `rsync -aH` over the network.

Once nothing is left on the old Mac, retire it (see [Retiring Truman](#retiring-truman)).

#### Day to day

`task switch` and `task diff` pick the flake output matching the machine's hostname. Cydonia's age key can't leave its Secure Enclave: to recover the secrets on other hardware, use the paper backup key.

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

## Secrets (sops + age)

Secrets are sops files encrypted with [age](https://age-encryption.org) and decrypted by sops-nix at every login and switch. `.sops.yaml` maps each secrets path to its recipients: every host has its own key plus a paper backup key.

| Path | Contents |
|---|---|
| `hosts/<host>/secrets/` | the host's secrets |
| `modules/home-manager/shared/secrets/` | secrets every host can read |
| `hosts/<host>/.keys/keys.txt` | the host's age identity (gitignored) |

### Host key in the Secure Enclave

On macOS hosts, generate the key with [age-plugin-se](https://github.com/remko/age-plugin-se). The key is bound to that Mac's Secure Enclave and can't be copied off it; `keys.txt` only holds a handle that is useless on any other machine.

```shell
cd ~/.config/nix-darwin
nix shell --inputs-from . nixpkgs-darwin#age nixpkgs-darwin#age-plugin-se
age-plugin-se keygen --access-control none -o hosts/Cydonia/.keys/keys.txt   # prints the public key (age1se1...)
age-plugin-se recipients -i hosts/Cydonia/.keys/keys.txt                     # prints it again, any time
```

`--access-control none` is required: sops-nix decrypts from a launchd agent with no UI to answer a Touch ID or password prompt.

Since that key can't be exported, also create a backup key that only ever exists on paper:

```shell
age-keygen      # write down the AGE-SECRET-KEY-1... line and note the public key; never save it to disk
age-keygen -y   # type the paper copy back in, then Ctrl-D: it must print the same public key
```

Close the terminal window afterwards so the backup key doesn't survive in the scrollback. To recover the secrets without the Mac, put the paper key in a file and point `SOPS_AGE_KEY_FILE` at it.

### Adding or removing a host

Declare the public keys in `.sops.yaml`, list them in the host's rule and in the `modules/home-manager/shared` rule, then re-encrypt every file on a host that can already decrypt them:

```yaml
keys:
  - &Cydonia age1se1...
  - &Cydonia_backup age1...
```

```shell
# Encrypting for an age1se1... recipient needs the plugin on PATH
nix shell --inputs-from . nixpkgs-darwin#age-plugin-se --command task sops_updatekeys
```

To remove a host, drop its keys from `.sops.yaml` and run the same command. That doesn't revoke what its key could already decrypt from git history: if the key is compromised, rotate the secrets themselves.

## Configuration Structure

The configuration is organized into a modular structure separating darwin-specific, nixos-specific, and shared configurations:

```bash
.
├── README.md
├── flake.nix
├── flake.lock
├── Makefile                       # fresh-Mac bootstrap, before `task` exists
├── Taskfile.yml                   # day-to-day tasks
├── hosts                          # per-host configurations
│   ├── Cydonia                    # macOS host (also used by Truman until it is decommissioned)
│   │   ├── default.nix            # main entrypoint for system-level customizations
│   │   ├── home.nix               # main entrypoint for user-level customizations
│   │   ├── apps.nix               # system-level app overrides
│   │   ├── ai.nix                 # AI/LLM configurations
│   │   ├── home-manager/          # host-specific home-manager configs
│   │   ├── secrets/               # SOPS encrypted secrets
│   │   └── .keys/                 # age identity (gitignored; bound to the Secure Enclave on Cydonia)
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
    │   │   ├── colima.nix
    │   │   ├── core.nix
    │   │   └── gpg.nix
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
    │       ├── claude-code/       # Claude Code module (see its README)
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

### Shared vs host boundary

Anything under `modules/*/shared` is consumed only by modules that every host imports. A host module (`hosts/<host>/...`) never imports a file from `shared`; when a host needs to vary something shared, the shared module exposes an option (`programs.claude-code.extraContext`, `hivemqCloudXmlPath` before it) and the host sets that option. Host-only material (secrets, pins, plugins used by one machine) lives under the host.

## Credits

I'm freely taking inspiration from a few repositories that have extremely well-organized definitions:
* https://github.com/JacobPEvans/nix
