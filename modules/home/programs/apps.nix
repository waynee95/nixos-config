{ inputs, pkgs, ... }:

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
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.codex
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
