{ pkgs, username, ... }:

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

      settings.General.GreeterEnvironment = "QML_XHR_ALLOW_FILE_READ=1,QML_DISABLE_DISK_CACHE=1";
    };
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.fprintAuth = false;

  environment.systemPackages = [ theme ];

  systemd.tmpfiles.rules = [
    "d /var/lib/AccountsService/icons 0775 root root -"
    "L+ /var/lib/AccountsService/icons/${username} - - - - ${../../../assets/avatar.jpg}"
  ];
}
