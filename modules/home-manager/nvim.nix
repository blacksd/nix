{pkgs, ...}: {
  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        dracula-nvim
        {
          plugin = vim-startify;
          config = "let g:startify_change_to_vcs_root = 0";
        }
      ];
    };
  };
}
