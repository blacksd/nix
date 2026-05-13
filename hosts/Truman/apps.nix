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
      "manaflow-ai/cmux"
      "skyhook-io/tap"
    ];

    # `brew install`
    brews = [
      "colima"
      "mqtt-cli"
      "tfvar" # TODO: This should be a nixpkg
      "tfenv" # TODO: This should be a nixpkg
      "nono"
      "radar"
    ];

    # `brew install --cask`
    casks = [
      # Let's make macOS better
      "elgato-stream-deck"
      "logitech-camera-settings"

      # Need a break
      "vlc"

      # Let's work
      "kitlangton-hex"
      "discord"
      "freelens"
      "rectangle-pro"
      "dbeaver-community"
      "tuple"
      "cmux"
      "bruno"

      # Cert stuff
      "xca"
      "keystore-explorer"

      # Java things
      "temurin"
      "visualvm"
    ];
  };
}
