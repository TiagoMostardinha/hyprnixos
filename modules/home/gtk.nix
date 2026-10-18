{ pkgs, ... }:

{
  # GTK apps (Thunar, nm-applet, blueman) use the Colloid icons (modules/nixos/icons.nix).
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };
}
