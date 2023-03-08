{ config, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ../../system ];

  boot.loader.grub.device = "/dev/nvme0n1";

  networking = {
    hostName = "waynee95-pc";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f0u8.useDHCP = true;
    wireless.enable = true;
    networkmanager.enable = false;
  };

  # Steam
  hardware = {
    opengl.driSupport32Bit = true;
    opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    pulseaudio.support32Bit = true;
    pulseaudio.package = pkgs.pulseaudioFull;
  };
}
