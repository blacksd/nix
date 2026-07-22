{pkgs, ...}: {
  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      # home-manager 26.05 flipped these defaults to false; keep the current
      # plugin set, none of which depend on Ruby/Python3 remote providers.
      withRuby = false;
      withPython3 = false;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        dracula-nvim
        # {
        #   plugin = vim-startify;
        #   config = "let g:startify_change_to_vcs_root = 0";
        # }
        # LazyVim
      ];
    };
    #   programs.nixvim = {
    #     enable = true;
    #     defaultEditor = true;
    #     opts = {
    #       number = true;
    #       shiftwidth = 2;
    #       completeopt = ["menu" "menuone" "noselect"];
    #       termguicolors = true;
    #     };
    #     colorscheme.dracula = {
    #       enable = true;
    #     };
    #   };
    # };
  };
}
