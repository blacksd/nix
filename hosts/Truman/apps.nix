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
      "logitech-camera-settings"

      # Let's work
      "discord"
      "lens"
      "rectangle-pro"

      # Cert stuff
      "xca"
      "keystore-explorer"

      # Java things
      "temurin"
      "visualvm"
    ];
  };
}
