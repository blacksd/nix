{pkgs, ...}: {
  home.file.".terraformrc".text = ''
    plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
  '';
  # Terraform does not create the cache dir itself.
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  home.packages = with pkgs; [
    ffmpeg
    yt-dlp
    wakeonlan
    ext4fuse
  ];
}
