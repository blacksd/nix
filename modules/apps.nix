{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  environment.systemPackages = with pkgs; [
    vim
    git
    go-task
    jq 
    jnv      # jq with dynamic filtering
    gh       # GitHub CLI tool
  ];
  environment.variables.EDITOR = "code --wait";

  # NOTE: To make this work, homebrew need to be installed manually, see https://brew.sh
  # 
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas 
    masApps = {
      # Xcode = 497799835;
      Magnet = 441258766;
      AppleConfigurator = 1037126344;
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    brews = [
    ];

    # `brew install --cask`
    casks = [
      # Let's make macOS better
      "iterm2"
      "stats"

      # Let's work
      "visual-studio-code"
      "aws-vault"

      # Let's try to survive the day
      "spotify"
    ];
  };
}
