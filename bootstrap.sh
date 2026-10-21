#!/bin/bash
# Fresh-Mac entrypoint, needs only curl: installs the Command Line Tools (git, make),
# clones this flake and hands over to `make bootstrap`.
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/blacksd/nix/main/bootstrap.sh)" -- <HOST>
# (not `curl | bash`: the installers and sudo need stdin on the terminal)
set -euo pipefail

HOST=${1:?usage: bootstrap.sh <HOST>}
DIR=$HOME/.config/nix-darwin # the path modules/home-manager/shared/age.nix expects

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish the Command Line Tools installer dialog; waiting for it to complete..."
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

# HTTPS: the GitHub SSH key is a sops secret, not available yet
[ -d "$DIR/.git" ] || git clone https://github.com/blacksd/nix "$DIR"
cd "$DIR"
make bootstrap HOST="$HOST"
