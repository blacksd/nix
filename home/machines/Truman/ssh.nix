{username, ...}: let
  fixedUsername = builtins.replaceStrings ["."] ["_"] username;
in {
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
