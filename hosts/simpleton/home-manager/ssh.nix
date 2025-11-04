{
  programs.ssh = {
    matchBlocks = {
      "edge" = {
        user = "admin";
        hostname = "192.168.20.1";
      };
    };
  };
}
