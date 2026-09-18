{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Julia Mono";
      bold_font = "Julia Mono Bold";
      bold_italic_font = "auto";
      font_size = 12;
      cursor_shape = "block";
      cursor_blink_interval = "-1";
      copy_on_select = "yes";
      url_style = "single";
      open_url_modifiers = "ctrl";
      enable_audio_bell = "no";
      # use XWayland in order to make wacom pen work
      linux_display_server = "x11";

      # hyper-snazzy colorscheme
      foreground = "#eff0eb";
      background = "#282a36";
      selection_foreground = "#000000";
      selection_background = "#FFFACD";
      url_color = "#0087BD";
      cursor = "#97979B";
      cursor_text_color = "#282A36";

      color0 = "#282a36";
      color8 = "#686868";
      color1 = "#FF5C57";
      color9 = "#FF5C57";
      color2 = "#5AF78E";
      color10 = "#5AF78E";
      color3 = "#F3F99D";
      color11 = "#F3F99D";
      color4 = "#57C7FF";
      color12 = "#57C7FF";
      color5 = "#FF6AC1";
      color13 = "#FF6AC1";
      color6 = "#9AEDFE";
      color14 = "#9AEDFE";
      color7 = "#F1F1F0";
      color15 = "#EFF0EB";
    };
  };
}
