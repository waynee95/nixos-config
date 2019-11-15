{ config, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ../../system ];

  boot.loader.grub.device = "/dev/sda";

  # See https://www.systutorials.com/docs/linux/man/5-wpa_supplicant.conf/
  networking = {
    hostName = "waynee95-thinkpad";
    networkmanager.enable = false;
    wireless.enable = true;
    useDHCP = false;
    interfaces = {
      enp0s25.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };

  services = {
    acpid.enable = true;

    libinput = {
      enable = true;
      naturalScrolling = true;
    };

    thinkfan = {
      enable = true;
      sensors = ''
        hwmon /sys/class/thermal/thermal_zone0/temp
      '';
      levels = ''
        (0, 0,  60)
        (1, 53, 65)
        (2, 55, 66)
        (3, 57, 68)
        (4, 61, 70)
        (5, 64, 71)
        (7, 68, 32767)
      '';
    };

    tlp = {
      enable = true;
      extraConfig = ''
        START_CHARGE_THRESH_BAT0=67
        STOP_CHARGE_THRESH_BAT0=100
      '';
    };
  };

}
