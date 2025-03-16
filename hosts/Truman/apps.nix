{pkgs, ...}: {
  homebrew = {
    masApps = {
      AppleConfigurator = 1037126344;
      NextMeeting = 1017470484;
    };

    taps = [
      "homebrew/services"
      "hivemq/mqtt-cli"
      "shihanng/tfvar"
    ];

    # `brew install`
    brews = [
      "colima"
      "mqtt-cli"
      "tfvar" # TODO: This should be a nixpkg
      "tfenv" # TODO: This should be a nixpkg
    ];

    # `brew install --cask`
    casks = [
      # Let's make macOS better
      "elgato-stream-deck"

      # Let's work
      "discord"
      "lens"
      "chatgpt"
      "xca"
      "keystore-explorer"
    ];
  };
}
