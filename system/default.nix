{ pkgs, lib, ... }:

{
  # Splash image instead of log messages
  boot.plymouth.enable = true;

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

  environment.variables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "termite";
  };

  environment.shellAliases = {
    b = "cd ..";
    bb = "cd ../..";
    q = "exit";

    dots = "cd ~/.dotfiles";
    drop = "cd ~/Dropbox";

    mkdir = "mkdir -p";
    rm = "rm -i";
    mv = "mv -i";
    cp = "cp -i";
  };

  environment.systemPackages = with pkgs; [
    acpi
    arandr
    coreutils
    curl
    dropbox-cli
    file
    firefox
    fish
    git
    htop
    pavucontrol
    scrot
    steam
    stow
    termite
    tmux
    tree
    unzip
    vim_configurable
    wget
    xclip
    youtube-dl
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

      displayManager = {
        gdm.enable = true;
        gdm.wayland = false;
      };

      desktopManager.gnome3.enable = true;
      desktopManager.xterm.enable = false;

      windowManager.stumpwm.enable = true;
    };
  };

  # See https://nixos.wiki/Gnome
  services.dbus.packages = with pkgs; [ gnome3.dconf gnome2.GConf ];

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-19.09";
      dates = "16:00";
    };
  };
}
