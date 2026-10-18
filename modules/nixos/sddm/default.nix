{ pkgs, username, ... }:

# Custom SDDM login screen ("glass"). The QML lives in ./theme. The wallpaper
# is the lock screen's (dotfiles/quickshell/assets), the avatar is assets/, and
# the status icons are Colloid (modules/nixos/icons.nix). SDDM 0.21 here is Qt6
# (QtVersion=6 in metadata.desktop). Quickshell cannot run inside the greeter,
# so this is plain Qt Quick.

let
  themeName = "glass";

  theme = pkgs.runCommand "sddm-theme-${themeName}" { } ''
    dest=$out/share/sddm/themes/${themeName}
    mkdir -p "$dest/assets"
    cp -r ${./theme}/. "$dest/"
    cp ${../../../dotfiles/quickshell/assets/wallpaper.jpg} "$dest/assets/wallpaper.jpg"
    cp ${../../../assets/avatar.jpg} "$dest/assets/avatar.jpg"
    ln -s ${pkgs.colloid-icon-theme}/share/icons/Colloid-Dark/status/symbolic "$dest/assets/icons"
  '';
in
{
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = themeName;

      # Environment of the greeter process.
      # - QML_XHR_ALLOW_FILE_READ: components/SystemStatus.qml reads battery and
      #   network state from /sys and /proc with XHR, which Qt only allows with this.
      # - QML_DISK_CACHE=none: Qt caches compiled QML by path + mtime, and every
      #   store file has the same mtime, so after a theme change the greeter ran
      #   the old compiled Main.qml and fell back to SDDM's default theme.
      settings.General.GreeterEnvironment = "QML_XHR_ALLOW_FILE_READ=1,QML_DISK_CACHE=none";
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  # SDDM finds themes in /run/current-system/sw/share/sddm/themes.
  environment.systemPackages = [ theme ];

  # SDDM shows /var/lib/AccountsService/icons/<user> as the avatar.
  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0775 root root -"
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${../../../assets/avatar.jpg}"
  ];
}
