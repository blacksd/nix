{
  config,
  username,
  ...
}: let
  fixedUsername = builtins.replaceStrings ["."] ["_"] username;
in {
  sops.secrets = {
    ssh_private_key_hivemq = {
      sopsFile = ../secrets/ssh.sops;
      format = "binary";
      path = "${config.home.homeDirectory}/.ssh/${fixedUsername}_hivemq";
    };
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        identityFile = "/Users/${username}/.ssh/${fixedUsername}_hivemq";
      };
    };
  };
}
