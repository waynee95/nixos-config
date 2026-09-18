{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swaybg
    hyprlock
    hypridle
    rofi
    brightnessctl
    playerctl
    hotkeyhub
    libnotify
  ];

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

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = pkgs.writeText "swayosd-style.css" ''
      window#osd {
        border: 2px solid #ffffff;
        border-radius: 8px;
        background: #000000;
      }

      window#osd #container {
        margin: 16px;
      }

      window#osd image,
      window#osd label {
        color: #ffffff;
      }

      window#osd progressbar,
      window#osd segmentedprogress {
        min-height: 6px;
        border: none;
        border-radius: 0;
        background: transparent;
      }

      window#osd trough,
      window#osd segment {
        min-height: inherit;
        border: 1px solid #ffffff;
        border-radius: 0;
        background: #000000;
      }

      window#osd progress,
      window#osd segment.active {
        min-height: inherit;
        border: none;
        border-radius: 0;
        background: #ffffff;
      }
    '';
  };

  systemd.user.targets.hyprland-session.Unit = {
    Description = "Hyprland session";
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };

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

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        # avoid starting multiple hyprlock instances
        lock_cmd = pidof hyprlock || hyprlock
        # lock before suspend
        before_sleep_cmd = loginctl lock-session
        # to avoid having to press a key twice to turn on the display
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
        # 2.5 minutes
        timeout = 150
        # set monitor backlight to minimum, avoid 0 on OLED monitor
        on-timeout = brightnessctl -s set 10
        # monitor backlight restore
        on-resume = brightnessctl -r
    }

    listener {
        # 5min
        timeout = 300
        # lock screen when timeout has passed
        on-timeout = loginctl lock-session
    }

    listener {
        # 5.5min
        timeout = 330
        # screen off when timeout has passed
        on-timeout = hyprctl dispatch dpms off
        # screen on when activity is detected after timeout has fired
        on-resume = hyprctl dispatch dpms on && brightnessctl -r
    }

    listener {
        # 30min
        timeout = 1800
        # suspend pc
        on-timeout = systemctl suspend
    }
  '';

  home.file.".config/hypr/hyprland.lua".text = ''
    local mainMod = "SUPER"

    hl.monitor({
      output   = "",
      mode     = "preferred",
      position = "auto",
      scale    = 1,
    })

    hl.config({
      general = {
        gaps_in     = 3,
        gaps_out    = 8,
        border_size = 2,
        col = {
          active_border   = { colors = { "rgba(57c7ffcc)", "rgba(5af78ecc)" }, angle = 45 },
          inactive_border = "rgba(282a36aa)",
        },
        layout = "dwindle",
      },

      dwindle = {
        preserve_split = true,
      },

      decoration = {
        rounding         = 4,
        active_opacity   = 1.0,
        inactive_opacity = 0.9,
        shadow = {
          enabled      = true,
          range        = 4,
          render_power = 3,
          color        = "rgba(00000055)",
        },
      },

      animations = {
        enabled = true,
      },

      input = {
        kb_layout    = "de",
        follow_mouse = 1,
        touchpad = {
          natural_scroll       = true,
          disable_while_typing = true,
          tap_to_click         = true,
        },
      },

      cursor = {
        inactive_timeout = 5,
      },

      -- remove the new version splash screen
      ecosystem = {
        no_update_news = true,
      },
    })

    hl.curve("easeOut", { type = "bezier", points = { { 0.2, 0.8 }, { 0.2, 1.0 } } })
    hl.animation({ leaf = "windows",    enabled = true, speed = 5, bezier = "easeOut", style = "slide" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOut", style = "slide" })
    hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "easeOut" })

    -- startup programs
    hl.on("hyprland.start", function()
      hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start hyprland-session.target")
      hl.exec_cmd("waybar")
      hl.exec_cmd("sh -c '$HOME/.local/bin/random-wallpaper.sh'")
      hl.exec_cmd("hypridle")
      hl.exec_cmd("nm-applet")
      hl.exec_cmd("hyprctl setcursor Adwaita 24")
    end)

    hl.on("hyprland.shutdown", function()
      hl.exec_cmd("systemctl --user stop hyprland-session.target")
    end)

    -- program keybinds 
    hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
    hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("kitty"))
    hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))
    hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
    hl.bind(mainMod .. " + W", hl.dsp.exit(), { description = "Exit Hyprland" })

    -- screen lock and poweroff
    hl.bind("ALT + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Lock screen" })
    hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("systemctl poweroff"), { description = "Power off" })

    -- media keys
    hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true, description = "Lock screen" })
    hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true, description = "Sleep" })
    hl.bind("XF86Display", hl.dsp.exec_cmd("cycle-display.sh"), { description = "Cycle display mode" })

    -- change focus 
    hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

    -- vim keys for focus
    hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
    hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
    hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }),   { description = "Focus up" })
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })

    -- switch workspaces
    for i = 1, 5 do
      hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    end

    -- split orientation
    hl.bind(mainMod .. " + S", hl.dsp.layout("preselect d"), { description = "Preselect split stacked" })
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.layout("preselect r"), { description = "Preselect split side-by-side" })
    hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"), { description = "Toggle split" })

    -- move windows to workspaces
    for i = 1, 5 do
      hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    end

    -- cycle windows 
    hl.bind(mainMod .. " + N", hl.dsp.window.cycle_next(), { description = "Next window" })
    hl.bind(mainMod .. " + P", hl.dsp.window.cycle_next({ next = false }), { description = "Previous window" })
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill(), { description = "Force-kill window" })
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("rofi -show run"), { description = "Run shell command" })

    -- toggle fullscreen and floating
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))

    -- show keybind cheatsheet using hotkeyhub
    hl.bind(mainMod .. " + SLASH", hl.dsp.exec_cmd("hotkeyhub --hyprland /home/waynee95/.config/hypr/hyprland.lua"), { description = "Keybind cheatsheet" })
    hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.exec_cmd("hotkeyhub --hyprland /home/waynee95/.config/hypr/hyprland.lua"), { description = "Keybind cheatsheet" })

    -- audio and brightness
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"))
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))

    -- screenshot
    hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" \"$HOME/Pictures/Screenshots/$(date '+%Y-%m-%d %H:%M:%S').png\""))
    -- screenshot (fullscreen)
    hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grim \"$HOME/Pictures/Screenshots/$(date '+%Y-%m-%d %H:%M:%S').png\""))

    -- window rules
    hl.window_rule({ match = { class = "xdg-desktop-portal" }, suppress_event = "maximize" })
    hl.window_rule({ match = { class = "^(firefox)$" }, opacity = "0.9 0.9" })
    hl.window_rule({ match = { class = "^(HotKeyHub|hotkeyhub)$" }, float = true, center = true, size = { 1200, 800 } })

    -- fix bitwarden's passkey selection window not being centered and not floating
    hl.on("window.title", function(w)
      if w == nil or w.class ~= "firefox" then
        return
      end
      if not w.title:match("^Extension: ") then
        return
      end
      hl.dispatch(hl.dsp.window.float({ action = "enable", window = w }))
      hl.dispatch(hl.dsp.window.resize({ x = 420, y = 600, relative = false, window = w }))
      hl.dispatch(hl.dsp.window.center({ window = w }))
    end)
  '';
}
