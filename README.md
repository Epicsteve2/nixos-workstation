## NixOS Workstation
setup guide:
- basically just do https://nixos.wiki/wiki/Btrfs
- add swap (can do after `nixos-enter`)
- regenerate hardware-configuration by running `nixos-generate-config --show-hardware-config`
- cp that into `hardware-configuration.nix`
- run the flake command!

## Other setup
- thunderbird
  - `tar czfv thunder.tar.gz ~/.thunderbird/`
  - `miniserve --hidden ~`
  - run thunderbird and untar all files to the new profile in local `~/.thunderbird/ `
