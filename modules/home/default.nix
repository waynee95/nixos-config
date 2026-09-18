{ ... }:

{
  imports = [
    ./shell/zsh.nix
    ./programs/git.nix
    ./programs/firefox.nix
    ./programs/apps.nix
    ./programs/kitty.nix
    ./programs/tmux.nix
    ./programs/nvim.nix
    ./programs/lf.nix
    ./programs/scripts.nix
    ./desktop/hyprland.nix
    ./desktop/gnome.nix
    ./desktop/waybar.nix
  ];

  home.username = "waynee95";
  home.homeDirectory = "/home/waynee95";
  home.stateVersion = "26.05";

  # see https://github.com/nix-community/home-manager
  programs.home-manager.enable = true;
}
