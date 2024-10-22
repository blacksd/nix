{
  username,
  hostname,
  ...
} @ args:
#############################################################
#
#  Host & Users configuration
#
#############################################################
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  # system.defaults.smb.NetBIOSName = hostname;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = "That's a-me, ${username}. And I manage this user with Nix!";
  };

  nix.settings.trusted-users = [username];
}
