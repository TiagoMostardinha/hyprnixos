{
  config,
  pkgs,
  username,
  hostname,
  ...
}:

let
  fingerTried = pkgs.writeShellScript "polkit-finger-tried" ''
    marker=/run/polkit-finger-tried-$PAM_USER
    case $1 in
      check) [ -n "$(${pkgs.findutils}/bin/find "$marker" -mmin -2 2>/dev/null)" ] ;;
      mark) ${pkgs.coreutils}/bin/touch "$marker" ;;
      forget) ${pkgs.coreutils}/bin/rm -f "$marker" ;;
    esac
  '';
  fingerTriedRule = order: control: step: {
    inherit order control;
    modulePath = "${pkgs.pam}/lib/security/pam_exec.so";
    args = [
      "quiet"
      "${fingerTried}"
      step
    ];
  };
  fprintdOrder = config.security.pam.services.polkit-1.rules.auth.fprintd.order;
in
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

  # Polkit waits up to 10 seconds for one finger, once per request; every retry after that is password only.
  security.pam.services.polkit-1.rules = {
    auth.fingerTriedSkip = fingerTriedRule (fprintdOrder - 50) "[success=1 default=ignore]" "check";
    auth.fprintd.args = [
      "max-tries=1"
      "timeout=10"
    ];
    auth.fingerTriedMark = fingerTriedRule (fprintdOrder + 50) "optional" "mark";
    account.fingerTriedForget = fingerTriedRule 12000 "optional" "forget";
  };

  services.hardware.bolt.enable = true;
  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
