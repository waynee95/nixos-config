{ pkgs, lib, ... }:

{
  # See https://github.com/NixOS/nixpkgs/issues/43461#issuecomment-554528899
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Splash image instead of log messages
  boot.plymouth.enable = true;

  time.timeZone = "Europe/Berlin";

  documentation.man.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config = { allowUnfree = true; };
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  fonts.fonts = with pkgs; [
    corefonts
    liberation_ttf
    ubuntu_font_family
    julia-mono
    nerdfonts
  ];

  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
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
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    acpi
    appimage-run
    arandr
    aspell
    coreutils
    curl
    discord
    dropbox-cli
    entr
    file
    firefox
    fzf
    gitAndTools.gitFull
    haskellPackages.nixfmt
    htop
    kitty
    megatools
    pandoc
    # texlive.combined.scheme-medium
    (texlive.combine {
      inherit (texlive)
        scheme-medium enumitem wrapfig tcolorbox environ diagbox pict2e;
    })
    pavucontrol
    scrot
    stow
    subversion
    tmux
    tree
    unrar
    unzip
    wget
    xclip
    haskellPackages.xmobar
    youtube-dl
    zip
  ];

  programs.zsh.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      customRC = ''
        luafile ${/home/waynee95/.config/nvim/init.lua}
      '';
    };
  };

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
      extraGroups = [ "networkmanager" "wheel" ];
      hashedPassword =
        "$6$VZg0KLhSW4Iquocr$D1bfuJp02pQgF9jUnH5/e.9wMBAv1AY5HCtP.uIJpcCtYEccPcnOiZJGdeEXg7myo.3LmQfX.W5smOs8OtDh41";
      shell = pkgs.zsh;
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

      desktopManager.gnome.enable = true;

      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;

      wacom.enable = true;
    };
  };

  system.stateVersion = "22.11";
}
