{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];
}
