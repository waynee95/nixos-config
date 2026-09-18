# nixos-config 

> my [nixos](https://nixos.org) config with [home-manager](https://github.com/nix-community/home-manager)

## System Setup

- **wm** [hyprland](https://hyprland.org)
- **terminal** kitty together with tmux
- **browser** firefox
- **shell** zsh 
- **editor** neovim with [lazy.nvim](https://lazy.folke.io)

## Layout

```
flake.nix                           # flake entry point
hosts/<machine>/configuration.nix   # per-machine config
modules/system/default.nix          # shared system-wide config
modules/home/                       # home-manager user config
```

## Setup

After installing NixOS, clone this repository.

```
sudo cp /etc/nixos/hardware-configuration.nix hosts/thinkpad_X230/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#thinkpad_X230
```

## Machines

- **thinkpad_X230** - ThinkPad X230 (waynee95-thinkpad)

## License

[MIT](LICENSE)
