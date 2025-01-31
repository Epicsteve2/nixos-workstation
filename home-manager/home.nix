{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  programs.home-manager.enable = true;
  home = {
    username = "stephen";
    homeDirectory = "/home/stephen";
  };
  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.firefox.profiles.default.settings = {
    "browser.tabs.tabMinWidth" = 200;
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    "widget.use-xdg-desktop-portal.location" = 1;
    "widget.use-xdg-desktop-portal.open-uri" = 1;
    "widget.use-xdg-desktop-portal.mime-handler" = 1;
    "widget.use-xdg-desktop-portal.settings" = 1;
  };
  services.copyq.enable = true;

  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    spectacle = {
      shortcuts = {
        captureRectangularRegion = "Print";
        captureCurrentMonitor = "Meta+Print";
      };
    };
    shortcuts = {
      kwin."Grid View" = "Meta+Tab";
      "services/Alacritty.desktop"."_launch" = "Meta+T";
      "services/com.github.hluk.copyq.desktop"."_launch" = "Meta+V";
      plasmashell."next activity" = "Meta+Shift+Tab";
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
      ksmserverrc = {
        General = {
          confirmLogout = false;
          loginMode = "emptySession";
        };
      };
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
            Environment = [
              "DISPLAY=:0"
              "PATH=/run/current-system/sw/bin"
            ];
            ExecStart = "/run/current-system/sw/bin/kanata --cfg /home/stephen/.config/kanata/asus-laptop.kbd";
            Type = "simple";
            Restart = "no";
          };
          Install = {
            WantedBy = [ "plasma-workspace.target" ];
          };
        };

        fusuma = {
          Unit = {
            Description = "Touchpad gestures";
          };
          Service = {
            Type = "simple";
            Restart = "no";
            ExecStart = "/run/current-system/sw/bin/fusuma";
            Environment = [
              "DISPLAY=:0"
              "PATH=/run/current-system/sw/bin"
            ];
            KillMode = "process";
          };
          Install = {
            WantedBy = [ "plasma-workspace.target" ];
          };
        };

        tmux = {
          Unit = {
            Description = "tmux server";
          };
          Service = {
            Type = "forking";
            ExecStart = "/run/current-system/sw/bin/tmux new-session -d";
            WorkingDirectory = "~";
            # ExecStop = "/run/current-system/sw/bin/tmux kill-session";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        thunderbird = {
          Unit = {
            Description = "Email client";
          };
          Service = {
            Type = "simple";
            ExecStart = "/run/current-system/sw/bin/thunderbird";
          };
          Install = {
            WantedBy = [ "plasma-workspace.target" ];
          };
        };

        strawberry = {
          Unit = {
            Description = "Music player";
          };
          Service = {
            Type = "simple";
            ExecStart = "/run/current-system/sw/bin/strawberry";
          };
          Install = {
            WantedBy = [ "plasma-workspace.target" ];
          };
        };
      };
    };
  };

  ## reload system units when changing configs. Commented out because I don't think I'd need it
  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
