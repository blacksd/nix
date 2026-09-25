{pkgs}:
# Pinned upstream skill: typesafe-ai/skills @ skills/typesafe-ai.
# Fetched at a fixed commit so the skill content is reproducible and
# lands in the Nix store instead of being pulled at runtime.
# To update: bump `rev`, then refresh each `hash` via
#   nix store prefetch-file --hash-type sha256 <url>
let
  rev = "65a39f393687675ce170e6094757de20370365b9";
  baseUrl = "https://raw.githubusercontent.com/typesafe-ai/skills/${rev}/skills/typesafe-ai";
in
  pkgs.runCommand "claude-skill-typesafe-ai" {} ''
    mkdir -p "$out"
    cp ${pkgs.fetchurl {
      url = "${baseUrl}/SKILL.md";
      hash = "sha256-ceqQ15BsZVTE9MRg73NhstJvWRFsza6YbcbZl7k4n1I=";
    }} "$out/SKILL.md"
    cp ${pkgs.fetchurl {
      url = "${baseUrl}/LICENSE";
      hash = "sha256-g18jPx1u2EqbmjUaugaJtHZEpBN9YxaRH8eVe95SOwI=";
    }} "$out/LICENSE"
  ''
