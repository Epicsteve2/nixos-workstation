{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.flameshot = { enable = true; };
  gtk = {
    enable = true;
    iconTheme.name = "Arc";
    iconTheme.package = pkgs.arc-icon-theme;
    theme.name = "Sweet-Dark";
    theme.package = pkgs.sweet;
  };

  programs = {
    vscode = {
      enable = true;
      userSettings = {
        "window.zoomLevel" = 2;
        "files.autoSave" = "afterDelay";
        "editor.formatOnSave" = true;
        "update.mode" = "none";
        "editor.fontFamily" =
          "'FiraCode Nerd Font', 'MesloLGS Nerd Font', 'Monofur Nerd Font'";
        "editor.formatOnPaste" = true;
        "editor.formatOnType" = true;
        "workbench.colorTheme" = "Monokai";
        "explorer.sortOrder" = "modified";
        "workbench.editor.highlightModifiedTabs" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.fontFamily" = "MesloLGS Nerd Font";
        "editor.fontLigatures" = true;
        "workbench.sideBar.location" = "right";
      };
      # extensions = with pkgs.vscode-extensions; [
      #   usernamehw.errorlens
      #   dcasella.i3
      #   brettm12345.nixfmt-vscode
      #   esbenp.prettier-vscode
      #   pkief.material-icon-theme
      #   bungcip.better-toml
      #   yzhang.markdown-all-in-one
      # ];
    };
    alacritty = {
      enable = true;
      settings = {
        working_directory = "~/code-monkey/nixos-workstation";
        background_opacity = 1;
        font = {
          size = 14;
          normal = {
            family = "MesloLGS Nerd Font";
            style = "Regular";
          };
        };
        selection.save_to_clipboard = true;
        cursor = { style.shape = "Beam"; };
        window = { dynamic_title = true; };
      };
    };
    rofi = {
      enable = true;
      font = "MesloLGS Nerd Font 14";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      location = "center";
    };

  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      # floating.modifier = "Mod4";
      modifier = "Mod4";
      fonts = {
        names = [ "MesloLGS Nerd Font" ];
        size = 14.0;
      };
      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+t" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "floating toggle";
          "${modifier}+d" =
            ''exec "${pkgs.rofi}/bin/rofi -modi drun,run -show drun"'';
        };
      startup = [
        {
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.nitrogen}/bin/nitrogen --restore";
          always = true;
          notification = false;
        }
      ];
      assigns = {
        "2: code" = [{ title = "Visual Studio Code"; }];
        # "1: code" = [{ title = "code"; }];
        # "2: web" = [{ class = "^Brave-browser$"; }];
        # "3: msg" = [{ class = "^Slack$"; } { class = "^discord$"; }];
        # "4: media" = [{ title = "^spt$"; }];
      };
    };
  };
  services.polybar = {
    enable = true;
    script = ''
      # Terminate already running bar instances
      # killall -q polybar
      # killall doesn't seem to kill the scripts started by the bar.
      # So, the following ways work better
      # kill $(ps aux | grep 'polybar' | awk '{print $2}')  >/dev/null 2>&1
      kill -9 $(pgrep -f 'polybar') >/dev/null 2>&1
      polybar-msg cmd quit >/dev/null 2>&1
      # Wait until the processes have been shut down
      while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
      # Launch bar1 and bar2
      polybar top &
    '';
  };
}
