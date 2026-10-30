{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases.sudo = "run0 --background=";
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Tiago Mostardinha";
      user.email = "tiago.mostardinha@ua.pt";
      init.defaultBranch = "main";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/github_ed25519.pub";
      signByDefault = true;
    };
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

  # Terminal apps (Terminal=true, like btop) open in kitty. Without this, uwsm can pick kitty-open.desktop,
  # kitty's URL opener, which is also marked as a terminal.
  xdg.configFile."xdg-terminals.list".text = ''
    kitty.desktop
  '';
}
