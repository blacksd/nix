{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}: let
  # Get wezterm from nixpkgs-unstable
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in {
  options.programs.wezterm.platformConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Platform-specific wezterm Lua configuration injected before return statement";
  };

  config.programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig =
      let
        baseConfig = builtins.readFile ./configs/wezterm.lua;
        platformConfig = config.programs.wezterm.platformConfig;
      in
        # Remove the final "return config" and add it back after platform config
        lib.removeSuffix "return config" baseConfig
        + platformConfig
        + "\nreturn config\n";
    package = pkgs-unstable.wezterm;
  };
}
