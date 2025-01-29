{ inputs, lib, config, pkgs, ... }: {
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  programs.home-manager.enable = true;
  home = {
    username = "stephen";
    homeDirectory = "/home/stephen";
  };

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
    workspace = { lookAndFeel = "org.kde.breezedark.desktop"; };
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
    ## doesn't really work
    # input.touchpads = [{
    #   disableWhileTyping = true;
    #   enable = true;
    # }]; 
    ## this probably isn't worth configuring here
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

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
