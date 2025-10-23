{
  config,
  username,
  ...
}: let
  fixedUsername = builtins.replaceStrings ["."] ["_"] username;
in {
  sops = {
    secrets = {
      ssh_private_key_hivemq = {
        sopsFile = ../secrets/ssh.sops;
        format = "binary";
        path = "${config.home.homeDirectory}/.ssh/${fixedUsername}_hivemq";
      };

      businessmap_api_key = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/api_key";
      };

      businessmap_base_url = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/base_url";
      };
    };

    templates."businessmap-env" = {
      content = ''
        export BUSINESSMAP_API_KEY="${config.sops.placeholder.businessmap_api_key}"
        export BUSINESSMAP_BASE_URL="${config.sops.placeholder.businessmap_base_url}"
      '';
    };
  };
}
