{ pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Keep Thunar preferences outside a full Xfce session.
  programs.xfconf.enable = true;

  # Mounting, trash, removable volumes and thumbnails.
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Archive manager used by thunar-archive-plugin.
  environment.systemPackages = [ pkgs.file-roller ];
}
