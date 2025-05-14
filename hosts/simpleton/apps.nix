{pkgs, ...}: {
  homebrew = {
    masApps = {
      Enpass = 732710998;
      Magnet = 441258766;
    };
    casks = [
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
    ];
  };
}
