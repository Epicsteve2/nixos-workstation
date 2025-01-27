# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # <plasma-manager/modules>
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  ## disabling cuz i wanna test tis first
  # programs.firefox.profiles.default.settings = {
  #   "browser.tabs.tabMinWidth" = 200;
  #   "widget.use-xdg-desktop-portal" = true; # doesn't work??
  #   # just do this i guess
  #   "widget.use-xdg-desktop-portal.file-picker" = 1;
  #   "widget.use-xdg-desktop-portal.location" = 1;
  #   "widget.use-xdg-desktop-portal.open-uri" = 1;
  #   "widget.use-xdg-desktop-portal.mime-handler" = 1;
  #   "widget.use-xdg-desktop-portal.settings" = 1;
  # };
  programs.plasma = {
    enable = true;

    workspace = {
      # clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      # cursor.theme = "Bibata-Modern-Ice";
      # iconTheme = "Papirus-Dark";
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };
    spectacle = {
      shortcuts = {
        captureRectangularRegion = "Print";
        captureCurrentMonitor = "Meta+Print";
      };
    };
    shortcuts = {
      kwin = { "Grid View" = "Meta+Tab"; };
      "services/Alacritty.desktop" = { "_launch" = "Meta+T"; };
      "services/com.github.hluk.copyq.desktop" = { "_launch" = "Meta+V"; };

    };
    ## doesn't rlly work
    # input.touchpads = [{
    #   disableWhileTyping = true;
    #   enable = true;
    # }]; 
    kwin = {
      virtualDesktops = {
        number = 9;
        rows = 3;
      };
    };
    configFile = {
      kwinrc = {
        Windows = {
          "BorderlessMaximizedWindows" = true;
          "FocusPolicy" = "FocusFollowsMouse";
          "RollOverDesktops" = true;
        };
      };
    };
    # startup = { startupScript = { fusuma = { text = "fusuma"; }; }; };
    ## this probably isn't worth it
    # window-rules = {
    #   thunderbird = {
    #     match = {
    #       windows-class = {
    #         value = "thunderbird";
    #         type = "exact";
    #       };
    #     };
    #   };
    # };
  };

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
  systemd = {
    user = {
      services = {
        kanata = {
          Unit = {
            Description = "Kanata keyboard remapper";
            Documentation = "https://github.com/jtroo/kanata";
          };
          Service = {
            Environment = [ "DISPLAY=:0" "PATH=/run/current-system/sw/bin" ];
            ExecStart =
              "/run/current-system/sw/bin/kanata --cfg /home/stephen/.config/kanata/asus-laptop.kbd";
            Type = "simple";
            Restart = "no";
          };
          Install = { WantedBy = [ "plasma-workspace.target" ]; };
        };

        fusuma = {
          Unit = { Description = "Touchpad gestures"; };
          Service = {
            Type = "simple";
            Restart = "no";
            ExecStart = "/run/current-system/sw/bin/fusuma";
            Environment = [ "DISPLAY=:0" "PATH=/run/current-system/sw/bin" ];
            KillMode = "process";
          };
          Install = { WantedBy = [ "plasma-workspace.target" ]; };
        };
      };
    };
  };

  home = {
    username = "stephen";
    homeDirectory = "/home/stephen";
  };

  ## maybe i should just copy the config folder...
  # accounts = {
  #   email = {
  #     accounts = {
  #       "work" = {
  #         address = "stephenguo14@gmail.com";
  #         flavor = "gmail.com";
  #         thunderbird = { enable = true; };
  #       };
  #     };
  #   };
  # };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
