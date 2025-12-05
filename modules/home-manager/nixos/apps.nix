{
  pkgs,
  username,
  ...
}: {
  # NixOS-specific core configuration
  home = {
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      vscode
    ];
  };

  # VSCode configuration
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
    };
  };
}
