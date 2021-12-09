{ config, pkgs, lib, ... }:

{
  imports = [
    ./polybar.nix
    ./rofi.nix
    ./i3.nix
    ./vscode.nix
    ./picom.nix
    ./alacritty.nix
  ];
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";

  home.stateVersion = "22.05";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  services.flameshot = { enable = true; };
  gtk = {
    enable = true;
    iconTheme.name = "Arc";
    iconTheme.package = pkgs.arc-icon-theme;
    theme.name = "Sweet-Dark";
    theme.package = pkgs.sweet;
    # cursor.package = pkgs.capitaine-cursors;
    # cursor.name = "Capitaine Cursors";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };
  xsession.enable = true;
}
