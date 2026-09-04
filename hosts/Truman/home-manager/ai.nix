{
  pkgs,
  llm-agents,
  ...
}: let
  llmPkgs = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = [
    llmPkgs.codex
    llmPkgs.nono
    llmPkgs.openspec
    llmPkgs.pi
  ];
}
