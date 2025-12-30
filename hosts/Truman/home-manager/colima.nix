{...}: {
  # Host-specific Colima profile configurations for Truman
  # These settings will be merged with the base defaults
  # from modules/home-manager/darwin/colima.nix

  programs.colima = {
    enable = true;
    profiles = {
      default = {
        cpu = 3;
        disk = 75;
      };
    };
    # NOTE: This is not supported upstream yet, but to create additional profiles:
    # production = {
    #   cpu = 8;
    #   memory = 16;
    #   disk = 100;
    #   kubernetes.enabled = true;
    # };
    #
    # dev = {
    #   cpu = 2;
    #   memory = 4;
    #   vmType = "qemu";
    # };
  };
}
