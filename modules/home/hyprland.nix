{ config, pkgs, ... }:

let
  repo = "${config.home.homeDirectory}/nixos-config";
  link = file: config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/hypr/${file}";
in
{
  # Linked file by file: hosts/<name>/home.nix generates hypr/host.lua next to them.
  # Hyprland resolves these symlinks, so require() looks in dotfiles/hypr/.
  xdg.configFile = {
    "hypr/hyprland.lua".source = link "hyprland.lua";
    "hypr/colors.lua".source = link "colors.lua";
    "hypr/binds.lua".source = link "binds.lua";
    "hypr/rules.lua".source = link "rules.lua";
    "hypr/autostart.lua".source = link "autostart.lua";
    "hypr/hyprpaper.conf".source = link "hyprpaper.conf";

    # UWSM loads these into every session (instead of hl.env in hyprland.lua).
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
    hyprlauncher # app launcher until Quickshell has one
    playerctl
    slurp
    swappy
    wf-recorder
    wl-clipboard
  ];

  # Wallpaper: config is dotfiles/hypr/hyprpaper.conf (settings = { } writes none).
  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  services.hyprpolkitagent.enable = true;
}
