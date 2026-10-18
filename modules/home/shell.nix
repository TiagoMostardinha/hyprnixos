{
  programs.zsh.enable = true;

  programs.kitty = {
    enable = true;

    # Package: modules/nixos/fonts.nix.
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };

    settings = {
      background = "#0a0e1a";
      foreground = "#e8ecf1";
      background_opacity = 0.72;
      dynamic_background_opacity = true;

      cursor_blink_interval = "0.5 ease-in-out";
      cursor_shape = "underline";
      cursor_shape_unfocused = "underline";
      cursor_underline_thickness = 2;

      window_padding_width = 4;
      window_border_width = 1;

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_background = "none";

      mouse_hide_wait = -1;
      scrollbar_jump_on_click = true;
      scrollback_lines = 10000;
    };
  };
}
