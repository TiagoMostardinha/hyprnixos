{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # programs.ssh.startAgent (core.nix) provides the SSH agent.
  services.gnome.gcr-ssh-agent.enable = false;

  # PAM service for the Quickshell lock screen (dotfiles/quickshell/panels/lock).
  security.pam.services.quickshell = { };

  # Tray applet until Quickshell has a network panel.
  programs.nm-applet.enable = true;
}
