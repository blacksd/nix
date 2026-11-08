{pkgs, ...}: {
  homebrew = {
    masApps = {
      Enpass = 732710998;
      iMovie = 408981434;
    };

    # NOTE: avoid this and prefer the native nix-darwin way
    #
    # taps = ["nikitabobko/tap"];

    # `brew install`
    brews = [
      "ykman"
      # CLI only: the tailscale-app cask doesn't put one on PATH. Never `brew services start` it, the app runs its own tailscaled
      "tailscale"
    ];

    casks = [
      # "aerospace"
      "macfuse"
      "rectangle"
      "ferdium"
      "google-chrome"
      #      "transmission-remote-gui"
      "vlc"
      "tor-browser"
      "calibre"
      "dropbox"
      "headlamp"
      "balenaetcher"
      "steam"
      "freelens"
      "audacity"
      "yubico-authenticator"
    ];
  };
}
