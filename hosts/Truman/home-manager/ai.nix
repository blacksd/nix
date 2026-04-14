{pkgs, ...}: {
  # codex comes from sadjow/codex-cli-nix overlay (see modules/system/darwin/nix-core.nix)
  home.packages = [pkgs.codex];
}
