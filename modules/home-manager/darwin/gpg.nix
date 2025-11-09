{pkgs, ...}: {
  # Darwin-specific GPG configuration
  home.packages = with pkgs; [
    pinentry_mac
  ];
}
