{pkgs, ...}: {
  homebrew = {
    masApps = {
      Enpass = 732710998;
      #  Magnet = 441258766;
    };

    # NOTE: avoid this and prefer the native nix-darwin way
    #
    # taps = ["nikitabobko/tap"];
    casks = [
      # "aerospace"
      "macfuse"
      "ferdium"
      "transmission-remote-gui"
      "vlc"
      "tor-browser"
      "calibre"
      "dropbox"
      "tailscale"
      "headlamp"
      "balenaetcher"
      "rectangle-pro"
    ];
  };
}
