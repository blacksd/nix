{pkgs, ...}: {
  # NixOS-specific applications
  home.packages = with pkgs; [
    vscode
  ];
}
