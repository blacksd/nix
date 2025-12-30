{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.colima;

  # Default configuration based on the existing colima.yaml
  baseDefaults = {
    cpu = 2;
    disk = 50;
    memory = 4;
    arch = "host";
    runtime = "docker";
    hostname = "colima";

    kubernetes = {
      enabled = false;
      version = "v1.31.2+k3s1";
      k3sArgs = ["--disable=traefik"];
      port = 0;
    };

    autoActivate = true;

    network = {
      address = true;
      mode = "";
      interface = "";
      preferredRoute = false;
      dns = [];
      dnsHosts = {
        "host.docker.internal" = "host.lima.internal";
      };
      hostAddresses = false;
    };

    forwardAgent = false;
    docker = {};
    vmType = "vz";
    portForwarder = "ssh";
    rosetta = true;
    binfmt = true;
    nestedVirtualization = false;
    mountType = "sshfs";
    mountInotify = false;
    cpuType = "host";
    provision = [];
    sshConfig = true;
    sshPort = 0;
    mounts = [];
    diskImage = "";
    rootDisk = 40;
    env = {};
  };

  yamlFormat = pkgs.formats.yaml {};

  # Validate that only 'default' profile is defined
  unsupportedProfiles = lib.filter (name: name != "default") (lib.attrNames cfg.profiles);

  # Generate a template file for each profile
  mkTemplateFile = name: profileConfig: let
    finalConfig = lib.recursiveUpdate baseDefaults profileConfig;
  in {
    name = ".colima/_templates/${name}.yaml";
    value = {
      source = yamlFormat.generate "${name}.yaml" finalConfig;
      onChange = ''
        mkdir -p ${config.home.homeDirectory}/.colima/_templates
      '';
    };
  };
in {
  options.programs.colima = {
    enable = lib.mkEnableOption "Colima VM configuration";

    profiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = ''
        Attribute set of Colima profile templates. Each attribute name becomes
        a template file at ~/.colima/_templates/<name>.yaml

        NOTE: Colima only reads from default.yaml for ALL new VMs, regardless of
        profile name. Other profile names are not currently supported by Colima.
        Only define a 'default' profile here.

        Templates are used when creating new Colima VMs. Once a VM is created,
        Colima manages the active config at ~/.colima/<name>/colima.yaml

        Each profile configuration will be merged with the base defaults.

        See https://github.com/abiosoft/colima for available options.
      '';
      example = lib.literalExpression ''
        {
          default = {
            cpu = 4;
            memory = 8;
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Validate only 'default' profile is used
    warnings = lib.optional (unsupportedProfiles != []) ''
      programs.colima.profiles: Colima only supports the 'default' profile template.
      The following profiles will be created but ignored by Colima: ${lib.concatStringsSep ", " unsupportedProfiles}
      Only ~/.colima/_templates/default.yaml is read when creating new VMs.
    '';

    # Generate template files only (Colima manages active configs)
    home.file = lib.mapAttrs' mkTemplateFile cfg.profiles;
  };
}
