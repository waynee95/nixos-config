{ ... }:

{
  # gtk file chooser settings for firefox
  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };
    "org/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
    };
  };
}
