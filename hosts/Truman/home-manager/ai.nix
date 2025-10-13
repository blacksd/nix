{pkgs, ...}: {
  home.packages = with pkgs; [
    codex
  ];

  programs.claude-code.enable = true;
}
