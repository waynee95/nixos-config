{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "waynee95-thinkpad";
  networking.networkmanager.enable = true;

  services.acpid.enable = true;

  # let hyprland handle the suspend and resume events
  services.logind.settings.Login.HandleSuspendKey = "ignore";

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # see https://wiki.archlinux.org/title/XDG_Desktop_Portal
  #     https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "hyprland" ];
      "hyprland" = {
        default = [ "gtk" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  hardware.graphics.enable = true;

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
      RUNTIME_PM_ON_BAT = "auto";

      BRIGHTNESS_START_LEVEL = 0;
    };
  };

  services.thinkfan = {
    enable = true;
    sensors = [
      {
        type = "hwmon";
        query = "/sys/class/hwmon";
        name = "coretemp";
      }
    ];
    levels = [
      [
        0
        0
        45
      ]
      [
        1
        40
        55
      ]
      [
        2
        50
        65
      ]
      [
        3
        60
        75
      ]
      [
        4
        70
        85
      ]
      [
        5
        80
        90
      ]
      [
        7
        85
        32767
      ]
    ];
  };

  system.stateVersion = "26.05";
}
