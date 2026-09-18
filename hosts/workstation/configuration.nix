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

  # use systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "waynee95-pc";
  networking.networkmanager.enable = true;

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

  system.stateVersion = "26.05";
}
