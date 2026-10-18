{
  config,
  lib,
  pkgs,
  username,
  ...
}:

# Login screen: greetd runs a minimal Hyprland whose only client is the
# Quickshell greeter (dotfiles/quickshell/greeter.qml). On success the greeter
# asks greetd to start the Hyprland (UWSM) session and exits; then this
# Hyprland exits too and greetd hands over to the session.
#
# Not hot-reloaded: the greeter runs as the `greeter` user and cannot read the
# repo in ~, so dotfiles/quickshell is copied into the store. Rebuild after edits.

let
  hyprland = config.programs.hyprland.package;
  quickshell = pkgs.quickshell;

  shellConfig = ../../dotfiles/quickshell;

  # What the greeter launches after a successful login (the same command as
  # the hyprland-uwsm.desktop session).
  session = pkgs.writeShellScript "hyprland-session" ''
    exec ${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland.desktop
  '';

  # Runs inside the greeter Hyprland: show the greeter, then end the compositor.
  greeter = pkgs.writeShellScript "quickshell-greeter" ''
    export QS_LOGIN_USER=${username}
    export QS_LOGIN_SESSION=${session}
    ${lib.getExe quickshell} -p ${shellConfig}/greeter.qml
    exec ${hyprland}/bin/hyprctl dispatch 'hl.dsp.exit()'
  '';

  # Hyprland config of the greeter compositor (Lua, Hyprland 0.55). Minimal:
  # no animations, no first-run popups, any monitor at its preferred mode.
  compositorConfig = pkgs.writeText "greeter-hyprland.lua" ''
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

    hl.env("PATH", "${lib.makeBinPath [ hyprland ]}:" .. (os.getenv("PATH") or ""))
    hl.env("XCURSOR_THEME", "oblique-cursor")
    hl.env("XCURSOR_SIZE", "20")
    hl.env("HYPRCURSOR_THEME", "oblique-cursor")
    hl.env("HYPRCURSOR_SIZE", "20")

    hl.config({
        animations = { enabled = false },
        decoration = { shadow = { enabled = false }, blur = { enabled = false } },
        input = { kb_layout = "${config.services.xserver.xkb.layout}" },
        ecosystem = { no_update_news = true, no_donation_nag = true },
        misc = {
            force_default_wallpaper  = 0,
            disable_hyprland_logo    = true,
            disable_splash_rendering = true,
            disable_watchdog_warning = true,
            disable_autoreload       = true,
            background_color         = "rgb(111111)",
        },
    })

    hl.on("hyprland.start", function ()
        hl.exec_cmd("${greeter}")
    end)
  '';
  # The greeter user's home is /var/empty (read-only): keep caches and state in
  # its runtime dir.
  compositor = pkgs.writeShellScript "greeter-compositor" ''
    export XDG_CACHE_HOME="$XDG_RUNTIME_DIR/cache"
    export XDG_STATE_HOME="$XDG_RUNTIME_DIR/state"
    export XDG_DATA_HOME="$XDG_RUNTIME_DIR/data"
    # Icon themes (Colloid), fonts and cursors installed system-wide.
    export XDG_DATA_DIRS="/run/current-system/sw/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    export XCURSOR_PATH=/run/current-system/sw/share/icons

    # Early in boot greetd can start before udev has set up the GPU that just
    # replaced the boot framebuffer (i915 over simpledrm), and Hyprland aborts.
    # Wait for udev, then retry only quick startup failures: once Hyprland has
    # run for a while, its exit (normally after a login) is final.
    # Output goes to the journal: journalctl -t greeter-hyprland
    ${pkgs.systemd}/bin/udevadm settle --timeout=10 || true
    for attempt in 1 2 3 4 5 6 7 8 9 10; do
      started=$SECONDS
      ${pkgs.systemd}/bin/systemd-cat -t greeter-hyprland \
        ${hyprland}/bin/Hyprland --config ${compositorConfig} && exit 0
      status=$?
      [ $((SECONDS - started)) -ge 5 ] && exit $status
      echo "Hyprland failed to start (attempt $attempt, status $status), retrying" \
        | ${pkgs.systemd}/bin/systemd-cat -t greeter-hyprland -p warning
      sleep 1
    done
    exit 1
  '';
in
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${compositor}";
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
