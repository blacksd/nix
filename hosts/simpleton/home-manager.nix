{pkgs, ...}: {
  imports = [
    ../../modules/home-manager 
  ];
  home.packages = with pkgs; [
    ffmpeg
  ];
}
