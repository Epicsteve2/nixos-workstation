clean:
  nix-collect-garbage --delete-old

switch:
  NIX_CONFIG="experimental-features = nix-command flakes"
  sudo nixos-rebuild switch --use-remote-sudo --flake . 
