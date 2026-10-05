# Bootstrap a fresh macOS host, before `task` exists (the config installs it; day-to-day
# tasks live in Taskfile.yml). Needs only the Command Line Tools (`xcode-select --install`),
# which provide git and this make (GNU Make 3.81: keep the syntax old-fashioned).

HOST ?= $(shell scutil --get LocalHostName 2>/dev/null)
# Absolute fallback: right after `make nix`, the current shell does not have nix on PATH yet
NIX := $(shell command -v nix 2>/dev/null || echo /nix/var/nix/profiles/default/bin/nix)
AGE_KEY := hosts/$(HOST)/.keys/keys.txt

.PHONY: help bootstrap nix brew hostname etc build switch age-key check-host

help: ## List targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

bootstrap: nix brew hostname etc switch ## Fresh Mac: Nix, Homebrew, hostname, first activation (HOST=<name>)

nix: ## Install upstream Nix (nix-darwin manages it; Determinate Nix would need nix.enable = false)
	@test -x $(NIX) || curl --proto '=https' --tlsv1.2 -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes

brew: ## Install Homebrew (skip its PATH advice: homebrew.enableZshIntegration handles it)
	@test -x /opt/homebrew/bin/brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

hostname: check-host ## Set the computer, local and host names to HOST
	sudo scutil --set ComputerName $(HOST)
	sudo scutil --set LocalHostName $(HOST)
	sudo scutil --set HostName $(HOST)

etc: ## Move the installer's /etc/nix/nix.conf aside so nix-darwin can manage it
	@if [ -f /etc/nix/nix.conf ] && [ ! -L /etc/nix/nix.conf ]; then sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin; fi

# nix-darwin comes from flake.lock (`--inputs-from .`), so it always matches the flake's release
build: check-host ## Build the HOST system without activating it
	sudo $(NIX) run --inputs-from . darwin#darwin-rebuild -- build --flake .#$(HOST) --option accept-flake-config true

switch: check-host ## Build and activate the HOST system
	sudo $(NIX) run --inputs-from . darwin#darwin-rebuild -- switch --flake .#$(HOST) --option accept-flake-config true

age-key: check-host ## Create HOST's Secure Enclave age key if missing and print its public key (GUI terminal, not SSH)
	@if [ -f $(AGE_KEY) ]; then \
	  $(NIX) shell --inputs-from . nixpkgs-darwin#age-plugin-se --command age-plugin-se recipients -i $(AGE_KEY); \
	else \
	  $(NIX) shell --inputs-from . nixpkgs-darwin#age-plugin-se --command age-plugin-se keygen --access-control none -o $(AGE_KEY); \
	fi

check-host:
	@grep -q 'darwinConfigurations."$(HOST)"' flake.nix || { echo "No darwinConfigurations.\"$(HOST)\" in flake.nix: pass HOST=<name>, e.g. make $(MAKECMDGOALS) HOST=Cydonia" >&2; exit 1; }
