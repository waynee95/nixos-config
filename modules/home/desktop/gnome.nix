{ pkgs, ... }:

{
  # override desktop entry and D-Bus activation service to pretend we are on GNOME,
  # otherwise gnome-control-center refuses to run unless XDG_CURRENT_DESKTOP contains
  # "GNOME" or "Unity"
  xdg.dataFile."applications/org.gnome.Settings.desktop".text = ''
    [Desktop Entry]
    Name=Settings
    Name[de]=Einstellungen
    Comment=GNOME Settings
    Comment[de]=GNOME-Einstellungen
    Exec=env XDG_CURRENT_DESKTOP=GNOME:Hyprland gnome-control-center
    Icon=org.gnome.Settings
    Terminal=false
    Type=Application
    StartupNotify=true
    Categories=GNOME;GTK;Settings;
  '';

  xdg.dataFile."dbus-1/services/org.gnome.Settings.service".text = ''
    [D-BUS Service]
    Name=org.gnome.Settings
    Exec=${pkgs.coreutils}/bin/env XDG_CURRENT_DESKTOP=GNOME:Hyprland ${pkgs.gnome-control-center}/bin/gnome-control-center --gapplication-service
  '';
}
