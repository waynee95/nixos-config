{ pkgs, ... }:

{
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        fixed-center = true;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "network"
          "pulseaudio"
          "battery"
          "tray"
        ];

        # NOTE: clicking on workspace buttons using the mouse in waybar is current broken
        #   https://github.com/Alexays/Waybar/issues/5035
        #   https://github.com/Alexays/Waybar/pull/5013
        "hyprland/workspaces" = {
          format = "{name}";
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
          interval = 60;
          on-click = "gnome-calendar";
          calendar = {
            mode = "month";
          };
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip-format = "{load}";
          interval = 2;
        };

        memory = {
          format = "󰍛 {used:0.1f}G";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
          interval = 2;
        };

        temperature = {
          thermal-zone = 1;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            "󱃃"
            "󰔏"
            "󱃂"
          ];
          critical-threshold = 90;
          interval = 2;
        };

        network = {
          format-wifi = "{icon} {essid}";
          format-ethernet = "{icon} {ifname}";
          format-disconnected = "󰤮 disconnected";
          format-icons = {
            wifi = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            ethernet = [ "󰈁" ];
            disconnected = [ "󰤮" ];
          };
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰕿"
              "󰕾"
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };

        battery = {
          bat = "BAT0";
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = {
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            charging = [
              "󰢟"
              "󰢜"
              "󰢝"
              "󰢞"
            ];
          };
          format-charging = "{icon} {capacity}%";
          format-full = " {capacity}%";
          format-plugged = " {capacity}%";
          "format-not-charging" = " {capacity}%";
          tooltip-format = "{capacity}% - {timeTo} ({power})";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(40, 42, 56, 0.9);
        color: #eff0eb;
      }

      #workspaces button {
        padding: 0 8px;
        min-width: 16px;
        color: #686868;
        background: transparent;
        border: none;
        box-shadow: none;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.08);
      }

      #workspaces button.active {
        color: #57c7ff;
        border-bottom: 2px solid #57c7ff;
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #battery,
      #tray {
        padding: 0 10px;
        margin: 0 2px;
        color: #eff0eb;
      }

      #battery.warning {
        color: #ffb86b;
      }

      #battery.critical {
        color: #ff5555;
      }
    '';
  };
}
