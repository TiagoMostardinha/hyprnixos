{ lib, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      curl
      fontconfig
      freetype
      glib
      icu
      libsecret
      libuuid
      openssl
      stdenv.cc.cc.lib
      xz
      zlib
    ];
  };

  networking.networkmanager.enable = true;
  programs.ssh.startAgent = true;

  time.timeZone = lib.mkDefault "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pt-latin1";
  services.xserver.xkb.layout = "pt";

  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    kitty.terminfo
    vim
    wget
  ];
}
