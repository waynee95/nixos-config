{ pkgs, lib, ... }:

{
  imports = [
   # Add home-manager module
    "${
      builtins.fetchGit {
        ref = "release-19.09";
        url = "https://github.com/rycee/home-manager";
      }
    }/nixos"
 ];

  time.timeZone = "Europe/Berlin";

  documentation.man.enable = true;

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  nix = { autoOptimiseStore = true; };

  nixpkgs.config = { allowUnfree = true; };

  fonts.fonts = with pkgs; [
    corefonts
    hack-font
    liberation_ttf
    ubuntu_font_family
  ];

  environment.systemPackages = with pkgs; [
    acpi
    arandr
    coreutils
    curl
    dropbox-cli
    fish
    git
    htop
    termite
    tmux
    tree
    unzip
    vim_configurable
    wget
    xclip
    zip
  ];

  programs.vim.defaultEditor = true;

  sound.enable = true;

  hardware = {
    bluetooth.enable = false;
    sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          office1 = {
            ip = "192.168.002.115";
            model = "DCP-1610W";
          };
        };
      };
    };
  };

  users = {
    extraUsers.waynee95 = {
      isNormalUser = true;
      createHome = true;
      home = "/home/waynee95";
      extraGroups = [ "wheel" ];
      hashedPassword =
        "$6$VZg0KLhSW4Iquocr$D1bfuJp02pQgF9jUnH5/e.9wMBAv1AY5HCtP.uIJpcCtYEccPcnOiZJGdeEXg7myo.3LmQfX.W5smOs8OtDh41";
      shell = pkgs.fish;
    };
    mutableUsers = false;
  };

  home-manager.users.waynee95 = { pkgs, ...}: {
    imports = [
      ../home
    ];
  };

  systemd.user.services.dropbox = {
    enable = true;
    description = "Dropbox service";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    path = with pkgs; [ dropbox-cli ];
    serviceConfig = {
      Type = "forking";
      PIDFile = "%h/.dropbox/dropbox.pid";
      ExecStart = "${pkgs.dropbox-cli}/bin/dropbox start";
      ExecStop = "${pkgs.dropbox-cli}/bin/dropbox stop";
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    xserver = {
      enable = true;
      layout = "de";

      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      displayManager = {
        gdm.enable = true;
        gdm.wayland = false;
      };

      desktopManager.gnome3.enable = true;
      desktopManager.xterm.enable = false;

      windowManager.stumpwm.enable = true;
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-19.09";
      dates = "16:00";
    };
  };

}
