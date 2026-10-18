{ pkgs, ... }:

# Colloid (https://github.com/vinceliuice/Colloid-icon-theme) is the icon theme
# for everything: Quickshell (IconTheme pragma), GTK apps (modules/home/gtk.nix),
# hyprtoolkit apps (dotfiles/hypr/hyprtoolkit.conf) and the SDDM login
# (modules/nixos/sddm). The variant in use is Colloid-Dark.
{
  environment.systemPackages = [ pkgs.colloid-icon-theme ];
}
