{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases.sudo = "run0 --background=";
  };

  programs.fzf.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      scrollback_lines = 10000;
      detect_urls = "yes";
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
    };
  };
}
