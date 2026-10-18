{
  config,
  lib,
  pkgs,
  ...
}:

# Idle chain (dotfiles/hypr/hypridle.conf): dim -> lock -> screen off -> suspend.

let
  repo = "${config.home.homeDirectory}/nixos-config";

  # Fade the backlight down/up.
  #   fade-brightness dim      remember the current level once, fade to 20% of it
  #   fade-brightness restore  fade back to the remembered level and forget it
  fadeBrightness = pkgs.writeShellApplication {
    name = "fade-brightness";
    runtimeInputs = [
      pkgs.brightnessctl
      pkgs.coreutils
    ];
    text = ''
      state="''${XDG_RUNTIME_DIR:-/tmp}/hypridle-brightness"
      steps=12

      fade() {
        local from=$1 to=$2 i
        for ((i = 1; i <= steps; i++)); do
          brightnessctl -q set $((from + (to - from) * i / steps))
          sleep 0.04
        done
      }

      case "''${1:-}" in
        dim)
          # Already dimmed: keep the original saved level.
          [ -e "$state" ] && exit 0
          cur=$(brightnessctl get)
          echo "$cur" > "$state"
          target=$((cur * 20 / 100))
          [ "$target" -lt 1 ] && target=1
          fade "$cur" "$target"
          ;;
        restore)
          [ -e "$state" ] || exit 0
          fade "$(brightnessctl get)" "$(cat "$state")"
          rm -f "$state"
          ;;
        *)
          echo "usage: fade-brightness dim|restore" >&2
          exit 1
          ;;
      esac
    '';
  };

  # Suspend only on battery: do nothing while any mains supply is online.
  suspendOnBattery = pkgs.writeShellApplication {
    name = "suspend-on-battery";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      for supply in /sys/class/power_supply/*; do
        [ "$(cat "$supply/type" 2>/dev/null)" = Mains ] || continue
        [ "$(cat "$supply/online" 2>/dev/null)" = 1 ] && exit 0
      done
      exec systemctl suspend
    '';
  };
in
{
  home.packages = [
    fadeBrightness
    suspendOnBattery
  ];

  xdg.configFile."hypr/hypridle.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/hypr/hypridle.conf";

  # Own unit instead of services.hypridle: that module pins PATH to a few
  # packages, so hypridle.conf could not call qs or the scripts above. This one
  # inherits the user manager's PATH (includes the user profile).
  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hyprland idle daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = lib.getExe pkgs.hypridle;
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
