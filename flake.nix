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
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

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
    nixpkgs-darwin,
    darwin,
    home-manager,
    krewfile,
    flake-utils,
    claude-code,
    sops-nix,
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

    # nix code formatter
    formatter = flake-utils.lib.eachDefaultSystemMap (
      system:
        nixpkgs-darwin.legacyPackages.${system}.alejandra
    );
  };
}
