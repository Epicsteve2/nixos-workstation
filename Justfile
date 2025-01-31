format:
  nixfmt --strict **/*.nix

clean:
  nix-collect-garbage --delete-old

# For the first time, run `nix shell nixpkgs#home-manager`
# To get KDE options, run `nix run github:nix-community/plasma-manager`
home-manager:
  home-manager switch --flake .#stephen@asus-vivobook

# if on installation media, run `NIX_CONFIG="experimental-features = nix-command flakes" nixos-install --flake .#asus-vivobook` instead
switch:
  nixos-rebuild switch --use-remote-sudo --flake .#asus-vivobook
