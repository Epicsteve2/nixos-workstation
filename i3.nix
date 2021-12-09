{ pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      gaps = {
        inner = 5;
        outer = 5;
      };
      workspaceLayout = "tabbed";

      bars = [ ];
      modifier = "Mod4";
      fonts = {
        names = [ "MesloLGS Nerd Font" ];
        size = 14.0;
      };
      keybindings =
        # let modifier = config.xsession.windowManager.i3.config.modifier; # rip idk hwo to do this anymore
        let modifier = "Mod4";
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "floating toggle";
          "${modifier}+d" = ''
            exec "${pkgs.rofi}/bin/rofi -modi drun,run -show drun -config ~/.config/rofi/rofidmenu.rasi"'';
          "${modifier}+Shift+d" = ''
            exec "${pkgs.rofi}/bin/rofi -show window -config ~/.config/rofi/rofidmenu.rasi"'';

          "Alt+Tab" = ''
            exec "${pkgs.rofi}/bin/rofi -show window -config ~/.config/rofi/rofidmenu.rasi"'';

          "${modifier}+Shift+e" = "exec ~/.config/i3/scripts/powermenu";
          "Print" = "exec flameshot gui";
        };
      startup = [
        {
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = "exec i3-msg workspace 1";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.numlockx}/bin/numlockx on";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.nitrogen}/bin/nitrogen --restore";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.picom}/bin/picom -CGb";
          always = true;
          notification = false;
        }

      ];
      assigns = {
        "2: code" = [{ title = "Visual Studio Code"; }];
        # "1: code" = [{ title = "code"; }];
        "3: web" = [{ class = "^Brave-browser$"; }];
        # "3: msg" = [{ class = "^Slack$"; } { class = "^discord$"; }];
        # "4: media" = [{ title = "^spt$"; }];
      };
      window.commands = [
        {
          command = "focus";
          criteria = { title = "Visual Studio Code"; };
        }
        {
          command = "focus";
          criteria = { class = "^Brave-browser$"; };
        }
      ];
    };
  };
}
