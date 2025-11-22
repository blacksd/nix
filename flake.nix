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
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    claude-code = {
      url = "github:roman/claude-code.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mcp-servers-nix = {
    #   url = "github:natsukium/mcp-servers-nix";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-darwin,
    darwin,
    home-manager,
    krewfile,
    flake-utils,
    claude-code,
    sops-nix,
    disko,
    # mcp-servers-nix,
    ...
  }: let
    specialArgs = {
      Truman =
        inputs
        // {
          username = "marco.bulgarini";
          useremail = "marco.bulgarini@hivemq.com";
          hostname = "Truman";
        };

      simpleton =
        inputs
        // {
          username = "marco";
          useremail = "marco.bulgarini@gmail.com";
          hostname = "simpleton";
        };

      rpi4 =
        inputs
        // {
          username = "marco";
          useremail = "marco.bulgarini@gmail.com";
          hostname = "rpi4";
        };

      minipc =
        inputs
        // {
          username = "marco";
          useremail = "marco.bulgarini@gmail.com";
          hostname = "minipc";
        };
    };
  in {
    darwinConfigurations."Truman" = darwin.lib.darwinSystem {
      specialArgs = specialArgs.Truman;
      system = "aarch64-darwin";
      modules = [
        ./hosts/${specialArgs.Truman.hostname}
      ];
    };

    darwinConfigurations."simpleton" = darwin.lib.darwinSystem {
      specialArgs = specialArgs.simpleton;
      system = "x86_64-darwin";
      modules = [
        ./hosts/${specialArgs.simpleton.hostname}
      ];
    };

    nixosConfigurations."rpi4" = nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs.rpi4;
      system = "aarch64-linux";
      modules = [
        disko.nixosModules.disko  # Required for nixos-anywhere
        ./hosts/${specialArgs.rpi4.hostname}
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs.rpi4;
            users.${specialArgs.rpi4.username} = import ./hosts/${specialArgs.rpi4.hostname}/home.nix;
          };
        }
      ];
    };

    nixosConfigurations."minipc" = nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs.minipc;
      system = "x86_64-linux";
      modules = [
        ./hosts/${specialArgs.minipc.hostname}
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs.minipc;
            users.${specialArgs.minipc.username} = import ./hosts/${specialArgs.minipc.hostname}/home.nix;
          };
        }
      ];
    };

    # nix code formatter
    formatter = flake-utils.lib.eachDefaultSystemMap (
      system:
        nixpkgs-darwin.legacyPackages.${system}.alejandra
    );
  };
}
