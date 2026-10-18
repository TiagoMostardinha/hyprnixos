{ pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
  };
}
