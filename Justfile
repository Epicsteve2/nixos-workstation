format:
    #!/usr/bin/env bash
    set -eux -o pipefail
    nixfmt --strict **/*.nix

clean:
    #!/usr/bin/env bash
    set -eux -o pipefail
    nh clean all --keep 5 --keep-since 30d
    # nh clean all --dry --keep 5 --keep-since 30d

# For the first time, run `nix shell nixpkgs#home-manager`

# To get KDE options, run `nix run github:nix-community/plasma-manager`
home-manager:
    #!/usr/bin/env bash
    set -eux -o pipefail
    home-manager switch --flake .#stephen@asus-vivobook

home-manager-nh:
    #!/usr/bin/env bash
    set -eux -o pipefail
    nh home switch ./ --configuration stephen@asus-vivobook

# if on installation media, run `NIX_CONFIG="experimental-features = nix-command flakes" nixos-install --flake .#asus-vivobook` instead
switch:
    #!/usr/bin/env bash
    set -eux -o pipefail
    nixos-rebuild switch --use-remote-sudo --flake .#asus-vivobook

## I don't really use this
# switch-nixos-cli:
#   #!/usr/bin/env bash
#   set -eux -o pipefail
#   nixos apply --yes .#asus-vivobook

switch-nh:
    #!/usr/bin/env bash
    set -eux -o pipefail
    # can add --verbose
    # --no-nom is to have download progress
    nh os switch --no-nom ./ --hostname asus-vivobook

update:
    #!/usr/bin/env bash
    set -eux -o pipefail
    nix flake update

enable-inputactions:
    #!/usr/bin/env bash
    set -eux -o pipefail
    qdbus org.kde.KWin /Effects org.kde.kwin.Effects.loadEffect kwin_gestures
