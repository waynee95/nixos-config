{ pkgs, ... }:

{
  imports = [
    ./random-wallpaper.nix
    ./swayosd.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];

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

  systemd.user.targets.hyprland-session.Unit = {
    Description = "Hyprland session";
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };

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
        kb_layout       = "de",
        follow_mouse    = 1,
        -- mouse natural scrolling
        natural_scroll  = true,
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
