{ lib, pkgs, ... }:

{
  # Monitors and per-device input for this laptop. dotfiles/hypr/hyprland.lua
  # loads this file last, so it overrides the shared fallback monitor rule.
  # Read real names and modes with `hyprctl monitors`.
  # Not hot-reloaded: run `hyprctl reload` after a rebuild.
  xdg.configFile."hypr/host.lua".text = ''
    hl.monitor({ output = "eDP-1",    mode = "2560x1600@60", position = "0x0",        scale = 2 })
    hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "-1920x-280", scale = 1 })
  '';

  # Convertible: rotate eDP-1, the touchscreen and the stylus with the
  # orientation sensor.
  systemd.user.services.iio-hyprland = {
    Unit = {
      Description = "Rotate the display with the orientation sensor";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.iio-hyprland;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Set once at install time. Never change it.
  home.stateVersion = "26.05";
}
