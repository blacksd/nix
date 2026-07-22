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
    settings = {
      "github.com" = {
        User = "git";
        HostName = "github.com";
        IdentityFile = "/Users/${username}/.ssh/${fixedUsername}_hivemq";
      };
    };
  };
}
