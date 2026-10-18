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
  home.packages = [ pkgs.quickshell ];

  # Live-editable: Quickshell reloads on save.
  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/quickshell";

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell desktop shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.quickshell;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
