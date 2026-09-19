{ ... }:

{
  # hyprlock: display time using english formatting
  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
      hide_cursor = true
    }

    background {
      color = rgb(282a36)
    }

    input-field {
      size = 300, 50
      position = 0, -80
      halign = center
      valign = center
      inner_color = rgb(282a36)
      font_color = rgb(eff0eb)
      outline_thickness = 2
      outer_color = rgb(57c7ff)
      rounding = 4
      placeholder_text = Password
    }

    label {
      text = $TIME
      font_size = 64
      font_family = FiraCode Nerd Font
      color = rgb(eff0eb)
      position = 0, 120
      halign = center
      valign = center
    }

    # cmd label: LC_TIME=C forces English day/month names.
    label {
      text = cmd[update:1000] LC_TIME=C date '+%A, %d %B %Y'
      font_size = 20
      font_family = FiraCode Nerd Font
      color = rgb(eff0eb)
      position = 0, 60
      halign = center
      valign = center
    }
  '';
}
