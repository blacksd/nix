{pkgs, ...}: let
  # Not in nixpkgs or Homebrew: repackage the upstream release DMG.
  m-flasher = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "m-flasher";
    version = "0.12.1";
    src = pkgs.fetchurl {
      url = "https://github.com/jvitkauskas/m-flasher/releases/download/v${version}/M-Flasher-${version}-macos.dmg";
      hash = "sha256-zLRpoc7q1QjlCkK2wClG6g0MruGKnQbsgwwmjuhxcZI=";
    };
    nativeBuildInputs = [pkgs.undmg];
    sourceRoot = "M-Flasher.app";
    installPhase = ''
      mkdir -p "$out/Applications/M-Flasher.app"
      cp -R . "$out/Applications/M-Flasher.app"
    '';
    meta.platforms = pkgs.lib.platforms.darwin;
  };
in {
  home.file.".terraformrc".text = ''
    plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
  '';
  # Terraform does not create the cache dir itself.
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    wakeonlan
    ext4fuse
    m-flasher
  ];
}
