# nixos-config

> my [nixos](https://nixos.org) config

## System Setup

- **wm** [stumpwm](https://stumpwm.github.io/)
- **terminal** termite together with tmux
- **browser** firefox
- **shell** fish with [pure.fish](https://github.com/brandonweiss/pure.fish)
- **editor** vim

## Setup

After installing NixOS, clone this repository.

```
rm /etc/nixos/configuration.nix
ln -s /<path_to_config>/nixos-config/machines/<name>/configuration.nix /etc/nixos/configuration.nix
nixos-rebuild switch
```

Run as root or using `sudo`.

## Inspired by

- https://github.com/sondr3/dotfiles
- https://github.com/davidak/nixos-config
- https://github.com/macalinao/dotfiles

## License

[MIT](LICENSE)
