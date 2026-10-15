{
  pkgs,
  lib,
  llm-agents,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  supported = builtins.hasAttr system llm-agents.packages;
  llmPkgs =
    if supported
    then llm-agents.packages.${system}
    else null;
in
  lib.mkIf supported {
    home.packages = [
      llmPkgs.openspec
    ];
  }
