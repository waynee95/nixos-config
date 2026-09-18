{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard # https://man.archlinux.org/man/wl-paste.1.en
    grim # https://man.archlinux.org/man/grim.1.en
    slurp # https://man.archlinux.org/man/extra/slurp/slurp.1.en
  ];

  home.file."bin/ide".text = ''
    #!/bin/sh
    tmux split-window -v -p 30
    tmux split-window -h -p 66
    tmux split-window -h -p 50
  '';

  home.file."bin/to_clip".text = ''
    #!/bin/sh
    wl-copy < "$1"
  '';

  home.file."bin/screenshot".text = ''
    #!/bin/sh
    mkdir -p "$HOME/Pictures/Screenshots"
    grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date "+%Y-%m-%d %H:%M:%S").png"
  '';

  home.file."bin/svndiffwrap.sh".text = ''
    #!/bin/sh
    nvim -d ''${6} ''${7}
  '';

  home.file.".local/bin/cycle-display.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -u

      state_file="''${XDG_RUNTIME_DIR:-/tmp}/display-cycle-state"

      mapfile -t monitors < <(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')

      internal=""
      external=""
      for m in "''${monitors[@]}"; do
        if [[ "$m" == eDP-* ]]; then
          internal="$m"
        elif [[ -z "$external" ]]; then
          external="$m"
        fi
      done

      # No external monitor connected: make sure internal is on, nothing to cycle.
      if [[ -z "$external" ]]; then
        ${pkgs.hyprland}/bin/hyprctl keyword monitor "''${internal:-eDP-1}, preferred, auto, 1"
        rm -f "$state_file"
        ${pkgs.libnotify}/bin/notify-send -t 2000 "Display" "No external monitor connected"
        exit 0
      fi

      mode="$(cat "$state_file" 2>/dev/null || echo internal)"

      case "$mode" in
        internal)
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "$internal, disable"
          echo external > "$state_file"
          ${pkgs.libnotify}/bin/notify-send -t 2000 "Display" "External only ($external)"
          ;;
        external)
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "$internal, preferred, auto-left, 1"
          echo extend > "$state_file"
          ${pkgs.libnotify}/bin/notify-send -t 2000 "Display" "Extend ($internal + $external)"
          ;;
        *)
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "$external, disable"
          ${pkgs.hyprland}/bin/hyprctl keyword monitor "$internal, preferred, auto, 1"
          echo internal > "$state_file"
          ${pkgs.libnotify}/bin/notify-send -t 2000 "Display" "Internal only ($internal)"
          ;;
      esac
    '';
  };
}
