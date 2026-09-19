{ pkgs, ... }:

{
  # pick a random wallpaper from ~/Pictures/Wallpapers on every login
  home.file.".local/bin/random-wallpaper.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      wallpaper_dir="''${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
      state_file="''${XDG_CACHE_HOME:-$HOME/.cache}/swaybg/last"

      [[ -d "$wallpaper_dir" ]] || exit 0

      mapfile -t candidates < <(
        ${pkgs.findutils}/bin/find "$wallpaper_dir" -type f \( \
          -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
          -iname "*.webp" -o -iname "*.bmp" \
        \) -print 2>/dev/null
      )

      [[ ''${#candidates[@]} -eq 0 ]] && exit 0

      mkdir -p "$(dirname "$state_file")"
      last="$(cat "$state_file" 2>/dev/null || true)"

      # avoid showing the same wallpaper twice in a row
      if [[ ''${#candidates[@]} -gt 1 && -n "$last" ]]; then
        pool=()
        for f in "''${candidates[@]}"; do
          [[ "$f" != "$last" ]] && pool+=("$f")
        done
        [[ ''${#pool[@]} -gt 0 ]] && candidates=("''${pool[@]}")
      fi

      wall="$(printf '%s\n' "''${candidates[@]}" | ${pkgs.coreutils}/bin/shuf -n 1)"

      # swaybg has no runtime control, so restart it with the new image
      ${pkgs.procps}/bin/pkill -x swaybg 2>/dev/null || true
      ${pkgs.swaybg}/bin/swaybg -i "$wall" -m fill &

      printf '%s\n' "$wall" > "$state_file"
    '';
  };
}
