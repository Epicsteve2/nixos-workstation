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
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import
      (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz")
      {
        inherit pkgs;
      };
  };
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";

  home.stateVersion = "22.05";
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  # Unfortunately. saving to different file seems to not work...
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        # # Probably some way to do this lol. I'm just bad at nix
        # savePath = builtins.concatStringsSep  builtins.getEnv "HOME";
        savePath = builtins.getEnv "HOME";
        savePathFixed = true;
        # hardcoded...
        ignoreUpdateToVersion = "0.10.1";
      };
      Shortcuts = {
        TYPE_SAVE = "Ctrl+S";
        TYPE_COPY = "Ctrl+C";
      };
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
      # name = "Arc";
      # package = pkgs.arc-icon-theme;
      # name = "Adwaita";
      # package = pkgs.gnome3.adwaita-icon-theme;
      # name = "Tela";
      # package = pkgs.tela-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.gnome_themes_standard;
      # name = "Sweet-Dark";
      # package = pkgs.sweet;
    };

    # gtk3.extraConfig = {
    # gtk-application-prefer-dark-theme = 0;
    # gtk-cursor-theme-name = "Adwaita";
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
    # };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };
  xsession = {
    enable = true;
    pointerCursor = {
      size = 40;
      package = pkgs.nur.repos.ambroisie.vimix-cursors;
      name = "Vimix-white-cursors";
      # name = "Vimix-cursors";

      # package = pkgs.capitaine-cursors;
      # name = "capitaine-cursors";

      # package = pkgs.nur.repos.ambroisie.volantes-cursors;
      # name = "volantes_light_cursors";
      # name = "volantes_cursors";

      # # Theres a lot of letters lol
      # package = pkgs.nur.repos.dan4ik605743.lyra-cursors;
      # name = "LyraF-cursors";
    };
  };
  # home.packages = with pkgs; [ arc-theme breeze-icons capitaine-cursors ];
}
