{
  config,
  lib,
  pkgs,
  ...
}:

let
  repo = "${config.home.homeDirectory}/nixos-config";
in
{
  xdg.configFile."hypr/hypridle.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/hypr/hypridle.conf";

  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hyprland idle daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.hypridle;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
