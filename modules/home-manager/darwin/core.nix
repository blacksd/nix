{
  pkgs,
  username,
  ...
}: {
  # Darwin-specific core configuration
  home = {
    homeDirectory = "/Users/${username}";

    packages = with pkgs; [
      devenv # Development environment tool
    ];
  };
}
