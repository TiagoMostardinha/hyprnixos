{
  config,
  lib,
  pkgs,
  username,
  ...
}:

# Login screen: greetd starts a minimal Hyprland (through UWSM, like the desktop
# session) whose only client is the Quickshell greeter (dotfiles/quickshell/greeter.qml).
# After a login the greeter asks greetd to start the desktop session, quits and
# stops this compositor.
#
# The greeter runs as the `greeter` user, which cannot read the repo in ~, so
# dotfiles/quickshell is copied into the store: rebuild after editing it.

let
  uwsm = lib.getExe config.programs.uwsm.package;
  startHyprland = "${config.programs.hyprland.package}/bin/start-hyprland";

  # Same command as the hyprland-uwsm.desktop session.
  session = pkgs.writeShellScript "hyprland-session" ''
    exec ${uwsm} start -e -D Hyprland hyprland.desktop
  '';

  greeter = pkgs.writeShellScript "quickshell-greeter" ''
    QS_LOGIN_USER=${username} QS_LOGIN_SESSION=${session} \
      ${lib.getExe pkgs.quickshell} -p ${../../dotfiles/quickshell}/greeter.qml
    ${uwsm} stop
  '';

  compositorConfig = pkgs.writeText "greeter-hyprland.lua" ''
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
    hl.env("HYPRCURSOR_THEME", "oblique-cursor")
    hl.env("HYPRCURSOR_SIZE", "20")
    hl.config({
        input = { kb_layout = "${config.services.xserver.xkb.layout}" },
        ecosystem = { no_update_news = true, no_donation_nag = true },
        misc = { disable_hyprland_logo = true, force_default_wallpaper = 0 },
    })
    hl.on("hyprland.start", function () hl.exec_cmd("${greeter}") end)
  '';
in
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${uwsm} start -e -D Hyprland -- ${startHyprland} -- --config ${compositorConfig}";
      user = "greeter";
    };
  };

  # Unlock the keyring with the login password.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Avatar shown by the greeter and the lock screen (services/User.qml).
  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0775 root root -"
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${../../assets/avatar.jpg}"
  ];
}
