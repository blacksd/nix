{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    devbox
    nix-prefetch
    nvd
    alejandra # I prefer this over nixfmt-rfc-style
    rsync
    wget
    htop
  ];
}
