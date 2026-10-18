# Dell Latitude 7340 (Raptor Lake-P, 2-in-1).
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

  # This disk has a separate ESP (/efi) and XBOOTLDR partition (/boot).
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

  # Early KMS: load the GPU driver in the initrd so the display is ready before
  # greetd starts the login screen (otherwise Hyprland can race i915 and abort).
  boot.initrd.kernelModules = [ "i915" ];

  # Hardware video acceleration for the Intel Iris Xe GPU.
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
  ];

  # Userspace stack for the IPU6 MIPI webcam.
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  # Orientation and ambient-light sensors over D-Bus (used by iio-hyprland).
  hardware.sensor.iio.enable = true;

  services.hardware.bolt.enable = true; # Thunderbolt
  services.thermald.enable = true; # Intel CPUs only

  # Set once at install time. Never change it.
  system.stateVersion = "26.05";
}
