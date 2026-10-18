{ pkgs, ... }:

{
  # System-wide so the SDDM greeter (runs as the sddm user) can use them too.
  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];
}
