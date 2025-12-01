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
}
