{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    warn-dirty = false;
    #   substituters = [
    #     # Query the mirror of USTC first, and then the official cache.
    #     "https://mirrors.ustc.edu.cn/nix-channels/store"
    #     "https://cache.nixos.org"
    #   ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    krewfile,
    flake-utils,
    ...
  }: let
    specialArgsTruman =
      inputs
      // {
        username = "marco.bulgarini";
        useremail = "marco.bulgarini@hivemq.com";
        hostname = "Truman";
      };

    specialArgsSimpleton =
      inputs
      // {
        username = "marco";
        useremail = "marco.bulgarini@gmail.com";
        hostname = "simpleton";
      };
  in {
    darwinConfigurations."Truman" = darwin.lib.darwinSystem {
      specialArgs = specialArgsTruman;
      system = "aarch64-darwin";
      modules = [
        ./modules/base/nix-core.nix
        ./modules/base/host-users.nix
        ./modules/base/system.nix
        ./modules/base/apps.nix

        ./modules/machines/Truman/apps.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgsTruman;
          home-manager.backupFileExtension = "home-manager-backup";
          home-manager.users.${specialArgsTruman.username} = import ./home/machines/Truman;
        }
      ];
    };

    darwinConfigurations."simpleton" = darwin.lib.darwinSystem {
      specialArgs = specialArgsSimpleton;
      system = "x86_64-darwin";
      modules = [
        ./modules/base/nix-core.nix
        ./modules/base/host-users.nix
        ./modules/base/system.nix
        ./modules/base/apps.nix

        ./modules/machines/simpleton/apps.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgsSimpleton;
          home-manager.backupFileExtension = "home-manager-backup";
          home-manager.users.${specialArgsSimpleton.username} = import ./home/machines/simpleton;
        }
      ];
    };

    # nix code formatter
    formatter = flake-utils.lib.eachDefaultSystem (system: {
      inherit (nixpkgs.legacyPackages.${system}) alejandra;
    });
  };
}
