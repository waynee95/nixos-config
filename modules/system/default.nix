{ pkgs, lib, ... }:

let
  # define the IP address of the printer/scanner
  # get the hostname of the printer using
  #     avahi-browse -rt _ipp._tcp | grep -o 'BRN[0-9A-F]*\.local'
  # then resolve the hostname to an IP using
  #     avahi-resolve -n BRN<mac>.local
  brotherIp = "192.168.178.32";
in
{
  # time and locale settings
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  documentation.man.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d --max 5";
  };

  nixpkgs.config.allowUnfree = true;

  # enable boot splash
  boot.plymouth.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # printing and scanning
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };

  # create the CUPS printer queue
  # see https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/printers.nix
  hardware.printers = {
    ensureDefaultPrinter = "Brother_DCP_1610W";
    ensurePrinters = [
      {
        name = "Brother_DCP_1610W";
        description = "Brother DCP-1610W";
        # since this is an old model, use socket instead of ipp://<ip>:631/ipp/print
        deviceUri = "socket://${brotherIp}";
        # get this using lpinfo -m | grep -i brother
        model = "drv:///brlaser.drv/br1610.ppd";
      }
    ];
  };

  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {
        Brother_DCP_1610W = {
          ip = brotherIp;
          model = "DCP-1610W";
        };
      };
    };
  };

  # disable bluetooth
  hardware.bluetooth.enable = false;

  # wacom
  services.xserver.wacom.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # enable docker via socket activation, not on boot
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  fonts.packages = with pkgs; [
    corefonts
    liberation_ttf
    ubuntu-classic
    julia-mono
    (nerd-fonts.fira-code)
    (nerd-fonts.jetbrains-mono)
    (nerd-fonts.symbols-only)
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # enable gnome keyring for password management for git
  security.pam.services.gdm-password.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    gnomeExtensions.appindicator
    acpi
    appimage-run
    aspell
    coreutils
    curl
    docker-sbx
    entr
    file
    fzf
    git
    htop
    pandoc
    pavucontrol
    subversion
    tmux
    tree
    unrar
    unzip
    wget
    zip
  ];

  programs.zsh.enable = true;

  environment.shellAliases = {
    b = "cd ..";
    bb = "cd ../..";
    q = "exit";
    quit = "exit";
    cls = "clear";
    mkdir = "mkdir -p";
    rm = "rm -i";
    mv = "mv -i";
    cp = "cp -i";
    # ls = "ls --group-directories-first --color=auto";
  };

  users.users.waynee95 = {
    isNormalUser = true;
    description = "waynee95";
    createHome = true;
    home = "/home/waynee95";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "26.05";
}
