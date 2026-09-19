{ pkgs, ... }:

{
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
}
