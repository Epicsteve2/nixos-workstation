## NixOS Workstation
setup guide:
- basicall just do https://nixos.wiki/wiki/Btrfs
- add swap (can do after nixos-enter)
- nixos-generate-config --show-hardware-config
- cp that into hardware-config.nix
- run the flake command!
