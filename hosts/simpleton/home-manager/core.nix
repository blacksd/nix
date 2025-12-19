{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    wakeonlan
    ext4fuse
    audacity
  ];
}
