{pkgs, ...}: {
  home.packages = with pkgs; [
    localsend
  ];

  programs = {
    java = {
      enable = true;
    };
  };
}
