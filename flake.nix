{
  description = "NixOS + Hyprland + Quickshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      username = "tiago";

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username hostname; };
          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
          ];
        };
    in
    {
      nixosConfigurations = {
        latitude-7340 = mkHost "latitude-7340";
      };
    };
}
