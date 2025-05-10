{pkgs, ...}: {
  homebrew = {
    masApps = {
      Enpass = 732710998;
      Magnet = 441258766;
    };
    casks = [
      "ferdium"
      "transmission-remote-gui"
      "vlc"
      "tor-browser"
      "calibre"
      "dropbox"
      "tailscale"
      "headlamp"
    ];
  };
}
