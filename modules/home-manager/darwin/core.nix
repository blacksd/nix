{pkgs, ...}: {
  # Darwin-specific core packages
  home.packages = with pkgs; [
    devenv  # Development environment tool
  ];
}
