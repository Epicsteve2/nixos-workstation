fmt:
  nixfmt nixos/configuration.nix nixos/hardware-configuration.nix
clean:
  nix-collect-garbage --delete-old

home-manager:
  # first time nix shell nixpkgs#home-manager
# also remember to git add
  home-manager switch --flake .#stephen@asus-vivobook
# get options nix run github:nix-community/plasma-manager

switch:
  NIX_CONFIG="experimental-features = nix-command flakes"
  nixos-rebuild switch --use-remote-sudo --flake .#asus-vivobook
  # if on installation media, run `nixos-install --flake .#nixos`
