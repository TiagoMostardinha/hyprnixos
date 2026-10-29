{
  pkgs,
  username,
  hostname,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = hostname;

  home-manager.users.${username}.imports = [ ./home.nix ];

  boot.loader = {
    timeout = 8;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    systemd-boot = {
      enable = true;
      xbootldrMountPoint = "/boot";
      configurationLimit = 10;
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
  ];

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.sensor.iio.enable = true;

  # Broadcom 58200 fingerprint reader (0a5c:5843): only Broadcom's TOD driver supports it.
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-broadcom;
  };

  # Polkit asks for the password after 10 seconds without a finger (pam_fprintd's default is 30, and 10 its minimum).
  security.pam.services.polkit-1.rules.auth.fprintd.args = [ "timeout=10" ];

  services.hardware.bolt.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
