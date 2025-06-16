{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "screen-256color";
    historyLimit = 64000;
    escapeTime = 6;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      {
        plugin = dracula;
        extraConfig = ''
          set-option -g @dracula-show-powerline true
          set-option -g @dracula-show-fahrenheit false
          set-option -g @dracula-military-time true
          set-option -g @dracula-plugins "cpu-usage battery weather time"
          set-option -g @dracula-fixed-location "Bergamo"
        '';
      }
    ];
    extraConfig = ''
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
    '';
  };
}
