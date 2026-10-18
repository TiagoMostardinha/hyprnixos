{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.imv
    # Zed and its Nix language servers.
    pkgs.zed-editor
    pkgs.nil
    pkgs.nixd
  ];

  programs.mpv.enable = true;

  programs.zathura = {
    enable = true;
    package = pkgs.zathura.override {
      plugins = [ pkgs.zathuraPkgs.zathura_pdf_mupdf ];
    };
  };

  programs.obsidian = {
    enable = true;
    vaults.notes.target = "Notes";
    defaultSettings.app = {
      alwaysUpdateLinks = true;
      spellcheck = true;
    };
  };
}
