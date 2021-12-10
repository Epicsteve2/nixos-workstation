{ config, pkgs, lib, ... }:

{
  imports = [
    ./polybar.nix
    ./rofi.nix
    ./i3.nix
    ./vscode.nix
    ./picom.nix
    ./alacritty.nix
    ./dunst.nix
  ];
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";

  home.stateVersion = "22.05";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  services.flameshot = { enable = true; };
  gtk = {
    enable = true;
    # iconTheme.name = "Arc";
    # iconTheme.package = pkgs.arc-icon-theme;
    iconTheme = {
      # name = "Arc";
      # package = pkgs.arc-icon-theme;
      # name = "Adwaita";
      # package = pkgs.gnome3.adwaita-icon-theme;
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      # name = "Adwaita-dark";
      # # package = pkgs.adwaita;
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };

    gtk3.extraConfig = {
      # gtk-application-prefer-dark-theme = 0;
      gtk-cursor-theme-name = "Adwaita";
      # gtk-cursor-theme-size = 0;
      # gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
      # gtk-toolbar-icon-size =
      #   "GTK_ICON_SIZE_LARGE_TOOLBAR"; # gtk-button-images = 1;
      # gtk-menu-images = 0;
      # gtk-enable-event-sounds = 1;
      # gtk-enable-input-feedback-sounds = 1;
      # gtk-xft-antialias = 1;
      # gtk-xft-hinting = 1;
      # gtk-xft-hintstyle = "hintfull";

    };
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
  home.packages = with pkgs; [ arc-theme breeze-icons capitaine-cursors ];
}
