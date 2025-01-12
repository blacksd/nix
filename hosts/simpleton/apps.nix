{pkgs, ...}: {
  homebrew = {
    masApps = {
      Enpass = 732710998;
    };
    casks = [
      "ferdium"
      "transmission-remote-gui"
      "vlc"
      "tor-browser"
      "calibre"
      "dropbox"
    ];
  };
}
