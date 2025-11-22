{
  config,
  pkgs,
  username,
  ...
}: {
  # Define user account
  users.users.${username} = {
    isNormalUser = true;
    description = "Marco B.";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL0m7Rvr/ReyLZZdMKU78oj3v7fGHRBriWDenQFFqbH5ziRWt0HubQMIzp6HS1848ATo5F6lu/BrFHWoMxTyJd4= marco@simpleton"
    ];
  };

  # Enable sudo without password for wheel group (optional, for convenience)
  security.sudo.wheelNeedsPassword = false;
}
