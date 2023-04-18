{ config, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ../../system ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "waynee95-pc";
  networking.networkmanager.enable = true;

  # https://nixos.wiki/wiki/Steam 
  programs.steam.enable = true;
}
