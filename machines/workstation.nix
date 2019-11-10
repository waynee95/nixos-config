{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../system
  ];

  boot.loader.grub.device = "/dev/nvme0n1";

  networking = {
    hostName = "waynee95-pc";
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
  };

}
