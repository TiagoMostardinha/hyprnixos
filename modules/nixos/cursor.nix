{ pkgs, ... }:

# oblique-cursor, a hyprcursor theme. Hyprland draws the cursor for Wayland
# apps. Selected with HYPRCURSOR_THEME (modules/home/hyprland.nix, greeter.nix).
let
  src = pkgs.fetchzip {
    url = "https://github.com/kayxean/oblique-cursor/releases/download/v1.0.0/oblique-cursor.tar.gz";
    hash = "sha256-pROJC0G2MTs5ktfMjISFrK9ZzZWE9upFuUzZLk/mdDo=";
  };
in
{
  environment.systemPackages = [
    (pkgs.linkFarm "oblique-cursor" [
      {
        name = "share/icons/oblique-cursor";
        path = src;
      }
    ])
  ];
}
