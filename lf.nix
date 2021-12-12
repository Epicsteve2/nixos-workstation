{ pkgs, ... }:
{
  programs.lf = {
    enable = true;
    previewer = {
      source = pkgs.writeShellScript "pv.sh" ''
        #!/bin/sh
        case "$1" in
            *.jpg) chafa --fill=block --symbols=block -c 256 -s 80x60 "$1" || exit 1;;
            *.png) chafa --fill=block --symbols=block -c 256 -s 80x60 "$1" || exit 1;;
            *.tar*) tar tf "$1";;
            *.zip) unzip -l "$1";;
            *.rar) unrar l "$1";;
            *.7z) 7z l "$1";;
            *.pdf) pdftotext "$1" -;;
            *) highlight -O ansi "$1" || bat --color=always --plain "$1";;
        esac
      '';
    };
  };
  #   nixpkgs.config.allowBroken = true;

  home.packages = with pkgs; [
    imv
    chafa
    # Broken package apparently
    # haskellPackages.pdftotext
    unrar
    p7zip
  ];
}
