{ pkgs, ... }:

# Colloid (https://github.com/vinceliuice/Colloid-icon-theme) is the icon theme
# for everything: Quickshell (IconTheme pragma), GTK apps (modules/home/gtk.nix)
# and hyprtoolkit apps (dotfiles/hypr/hyprtoolkit.conf). The variant in use is
# Colloid-Dark. System-wide so the greeter user finds it as well.
{
  environment.systemPackages = [ pkgs.colloid-icon-theme ];
}
