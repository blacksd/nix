#!/bin/bash
# Fresh-Mac entrypoint, needs only curl: installs the Command Line Tools (git, make) unattended,
# clones this flake and hands over to `make bootstrap`.
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/blacksd/nix/main/bootstrap.sh)" -- <HOST>
# BRANCH=<branch> clones a branch other than the default, to try changes before merging.
# (not `curl | bash`: the installers and sudo need stdin on the terminal)
set -euo pipefail

HOST=${1:?usage: bootstrap.sh <HOST>}
DIR=$HOME/.config/nix-darwin # the path modules/home-manager/shared/age.nix expects

if ! xcode-select -p >/dev/null 2>&1; then
  # Headless install, as Homebrew's installer does: this marker makes softwareupdate
  # list the Command Line Tools, and installing from there skips the GUI and the EULA.
  marker=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  touch "$marker"
  label=$(softwareupdate -l 2>/dev/null | grep -B1 -E 'Command Line Tools' |
    awk -F'*' '/^ *\*/ {print $2}' | sed -e 's/^ *Label: //' -e 's/^ *//' | sort -V | tail -n1)
  [ -z "$label" ] || sudo softwareupdate -i "$label"
  rm -f "$marker"
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish the Command Line Tools installer dialog; waiting for it to complete..."
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  fi
fi

# HTTPS: the GitHub SSH key is a sops secret, not available yet
[ -d "$DIR/.git" ] || git clone ${BRANCH:+-b "$BRANCH"} https://github.com/blacksd/nix "$DIR"
cd "$DIR"
make bootstrap HOST="$HOST"
