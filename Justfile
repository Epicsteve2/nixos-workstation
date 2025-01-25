fmt:
  nixfmt nixos/configuration.nix nixos/hardware-configuration.nix
clean:
  nix-collect-garbage --delete-old

switch:
  NIX_CONFIG="experimental-features = nix-command flakes"
  nixos-rebuild switch --use-remote-sudo --flake .#nixos
  # if on installation media, run `nixos-install --flake .#nixos`
