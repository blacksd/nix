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

      hivemq_cloud_xml = {
        sopsFile = ../secrets/hivemq_cloud.xml.sops;
        format = "binary";
      };

      businessmap_api_token = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/api_token";
      };

      businessmap_api_url = {
        sopsFile = ../secrets/mcp.sops.yaml;
        key = "kanbanize/api_url";
      };
    };

    templates."businessmap-env" = {
      content = ''
        export BUSINESSMAP_API_URL="${config.sops.placeholder.businessmap_api_url}"
        export BUSINESSMAP_API_TOKEN="${config.sops.placeholder.businessmap_api_token}"
      '';
    };
  };
}
