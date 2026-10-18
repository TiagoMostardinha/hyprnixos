{ config, pkgs, ... }:

let
  repo = "${config.home.homeDirectory}/nixos-config";
  link = file: config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/hypr/${file}";
in
{
  xdg.configFile = {
    "hypr/hyprland.lua".source = link "hyprland.lua";
    "hypr/colors.lua".source = link "colors.lua";
    "hypr/binds.lua".source = link "binds.lua";
    "hypr/rules.lua".source = link "rules.lua";
    "hypr/hyprpaper.conf".source = link "hyprpaper.conf";
    "hypr/hyprtoolkit.conf".source = link "hyprtoolkit.conf";

    "uwsm/env".text = ''
      export HYPRCURSOR_THEME=oblique-cursor
      export HYPRCURSOR_SIZE=20
      export XCURSOR_THEME=oblique-cursor
      export XCURSOR_SIZE=20
    '';

    "swappy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures/Screenshots
      save_filename_format=swappy-%Y%m%d-%H%M%S.png
      show_panel=true
    '';
  };

  home.packages = with pkgs; [
    brightnessctl
    grim
    hyprlauncher
    playerctl
    slurp
    swappy
    wf-recorder
    wl-clipboard
  ];

  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  services.hyprpolkitagent.enable = true;
}
