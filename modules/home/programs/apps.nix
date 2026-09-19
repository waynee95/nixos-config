{ inputs, pkgs, ... }:

let
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # see https://discourse.nixos.org/t/opencode-server-error-workaround/80088
  bun_1_3_13 = unstablePkgs.bun.overrideAttrs (old: rec {
    version = "1.3.13";
    src = unstablePkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
      hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
    };
  });

  opencode = unstablePkgs.opencode.override { bun = bun_1_3_13; };
in
{
  home.packages =
    with pkgs;
    [
      obsidian
      zotero
      discord
      zoom-us
      element-desktop
      nextcloud-client
      dropbox
    ]
    ++ [
      opencode
      unstablePkgs.codex
    ];

  # start dropbox via systemd user service on login
  systemd.user.services.dropbox = {
    Unit = {
      Description = "Dropbox service";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      PIDFile = "%h/.dropbox/dropbox.pid";
      ExecStart = "${pkgs.dropbox}/bin/dropbox start";
      ExecStop = "${pkgs.dropbox}/bin/dropbox stop";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # start nextcloud client via systemd user service on login
  systemd.user.services.nextcloud = {
    Unit = {
      Description = "Nextcloud client";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
