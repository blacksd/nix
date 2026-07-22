{pkgs, ...}: {
  homebrew = {
    masApps = {
      AppleConfigurator = 1037126344;
      NextMeeting = 1017470484;
    };

    # Homebrew 6.0.0 enabled HOMEBREW_REQUIRE_TAP_TRUST by default, which refuses
    # to load formulae/casks from third-party taps unless they are marked trusted.
    # Set `trusted = true` on any non-official tap whose formulae/casks are listed
    # in `brews`/`casks` below; official taps (homebrew/*) are always trusted.
    taps = [
      "homebrew/services"
      {
        name = "hivemq/mqtt-cli";
        trusted = true;
      }
      {
        name = "shihanng/tfvar";
        trusted = true;
      }
      {
        name = "manaflow-ai/cmux";
        trusted = true;
      }
      {
        name = "skyhook-io/tap";
        trusted = true;
      }
    ];

    # `brew install`
    brews = [
      "colima"
      "mqtt-cli"
      "tfvar" # TODO: This should be a nixpkg
      "tfenv" # TODO: This should be a nixpkg
      "radar"
      "sem-cli"
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
