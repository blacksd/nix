{
  pkgs,
  lib,
  llm-agents,
  ...
}: let
  llmPkgs = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  jsonFormat = pkgs.formats.json {};
  tomlFormat = pkgs.formats.toml {};

  # Codex reads and writes the same file: CODEX_HOME/config.toml holds both
  # declarative preferences and runtime state (projects.*.trust_level accepted
  # in the TUI, notice.model_migrations, approval rules). Unlike Claude Code it
  # has no separate mutable store, no config.d drop-in directory, and its only
  # read-only layer is the MDM managed_config.toml. So the file cannot be a
  # /nix/store symlink: Codex resolves the link before its atomic write and
  # fails with "failed to persist config".
  #
  # The settings below are therefore overlaid onto the live file on every
  # activation instead of replacing it. Declared keys are authoritative; keys
  # Codex added at runtime survive. Caveat: a key removed from this set is no
  # longer overwritten, so it lingers in the live file until deleted by hand.
  codexSettings = {
    personality = "pragmatic";
    model = "gpt-5.6-terra";
    model_reasoning_effort = "xhigh";

    tui.alternate_screen = "never";

    projects = {
      "/Users/marco.bulgarini/Repositories/cue".trust_level = "untrusted";
      "/Users/marco.bulgarini/Repositories/cue-hive".trust_level = "trusted";
      "/Users/marco.bulgarini/Repositories/hivemq-enterprise".trust_level = "trusted";
      "/Users/marco.bulgarini/Repositories/apiary-base".trust_level = "trusted";
      "/Users/marco.bulgarini/.config/nix-darwin".trust_level = "trusted";
    };
  };

  codexSettingsFile = tomlFormat.generate "codex-config.toml" codexSettings;

  codexMergeConfig = pkgs.writers.writePython3 "codex-merge-config" {
    libraries = [pkgs.python3Packages.tomli-w];
  } ''
    """Overlay the declared Codex settings onto the live config.toml.

    Usage: codex-merge-config DECLARED_TOML TARGET_TOML
    """

    import os
    import shutil
    import sys
    import tomllib

    import tomli_w


    def overlay(base, declared):
        """Recursively overlay declared onto base. Declared wins on conflict."""
        merged = dict(base)
        for key, value in declared.items():
            current = merged.get(key)
            if isinstance(value, dict) and isinstance(current, dict):
                merged[key] = overlay(current, value)
            else:
                merged[key] = value
        return merged


    def read_live(path):
        """Return the current on-disk config, or {} if there is none to keep."""
        if os.path.islink(path):
            # Leftover read-only store symlink from programs.codex.settings.
            os.unlink(path)
            return {}
        if not os.path.exists(path):
            return {}
        try:
            with open(path, "rb") as handle:
                return tomllib.load(handle)
        except tomllib.TOMLDecodeError as error:
            shutil.copyfile(path, path + ".unparsable")
            print("codex config.toml unparsable, kept a copy:", error)
            return {}


    def main():
        declared_path, target = sys.argv[1], sys.argv[2]
        with open(declared_path, "rb") as handle:
            declared = tomllib.load(handle)

        merged = overlay(read_live(target), declared)

        scratch = target + ".hm-new"
        with open(scratch, "wb") as handle:
            tomli_w.dump(merged, handle)
        os.chmod(scratch, 0o644)
        os.replace(scratch, target)


    main()
  '';

  # Pi's default model. DeepSeek's latest flash model is provided by Pi's
  # built-in models-store, so it needs no custom entry in models.json.
  piDefaultProvider = "openrouter";
  piDefaultModel = "~deepseek/deepseek-flash-latest";

  # Pi rewrites settings.json at runtime (theme changes, lastChangelogVersion,
  # etc.), so it is deployed as a writable copy rather than a store symlink.
  # Only the declarative defaults below are managed; runtime mutations persist.
  piSettings = {
    theme = "dark";
    defaultProvider = piDefaultProvider;
    defaultModel = piDefaultModel;
    defaultThinkingLevel = "medium";
  };

  piSettingsFile = jsonFormat.generate "pi-settings.json" piSettings;
in {
  home.packages = [
    llmPkgs.nono
    llmPkgs.omnigent
    llmPkgs.openspec
    llmPkgs.pi
  ];

  # Keep Codex packaged by llm-agents.nix. `settings` is left empty so Home
  # Manager does not manage CODEX_HOME/config.toml; the activation script below
  # deploys it instead. See the codexSettings comment above.
  programs.codex = {
    enable = true;
    package = llmPkgs.codex;
    settings = {};
  };

  # Merge rather than install: the declared settings win, anything Codex wrote
  # at runtime is carried over. See the codexSettings comment above.
  home.activation.codexSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.codex"
    run ${codexMergeConfig} ${codexSettingsFile} "$HOME/.codex/config.toml"
  '';

  # settings.json is deployed as a writable copy (not a store symlink) because
  # Pi mutates it on load; a read-only symlink would break those runtime writes.
  home.activation.piSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.pi/agent"
    if [ -L "$HOME/.pi/agent/settings.json" ]; then
      run rm -f "$HOME/.pi/agent/settings.json"
    fi
    run install -m 0644 ${piSettingsFile} "$HOME/.pi/agent/settings.json"
  '';
}
