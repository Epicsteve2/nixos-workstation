# NixOS Workstation
I just followed [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## Initial setup guide

- Setup filesystem. I used [this guide](https://nixos.wiki/wiki/Btrfs)
  - I added a swap BTRFS subvolume as well (can do after running `nixos-enter` into the mounted partitions after installing)
- regenerate hardware-configuration by running `nixos-generate-config --show-hardware-config` and copy to `./nixos/hardware-configuration.nix`
- run the flake command: `nixos-rebuild switch --use-remote-sudo --flake .#asus-vivobook`
- setup password for `stephen`
- switch user and run home-manager

## Other setup
- Plasma
  - setup new activity
  - import window rules
  - add tmux and thunderbird autostart
- Thunderbird
  - backup from old computer by running the command: `tar --create --gzip --verbose --file thunder.tar.gz ~/.thunderbird/`
  - run Thunderbird once on the new computer and untar all files to the newly created profile at `~/.thunderbird/`
