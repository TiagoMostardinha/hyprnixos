{
  inputs,
  pkgs,
  username,
  hostname,
  ...
}:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.${username} = {
    isNormalUser = true;
    description = "Tiago";
    extraGroups = [
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = { inherit inputs username hostname; };
    users.${username}.imports = [ ../home ];
  };
}
