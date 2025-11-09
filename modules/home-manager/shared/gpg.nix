{
  pkgs,
  useremail,
  ...
}: {
  home.packages = with pkgs; [
    gnupg
  ];
  programs.gpg = {
    enable = true;
    # Based on https://alexcabal.com/creating-the-perfect-gpg-keypair
    settings = {
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      default-preference-list = "SHA512";
      keyserver = "keyserver.ubuntu.com";
      default-key = useremail;
    };
  };
  # NOTE: it's working fine without the explicit selection
  # Also, there's a bug https://github.com/nix-community/home-manager/issues/3864
  # services.gpg-agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry_mac;
  # };
}
