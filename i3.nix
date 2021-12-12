{ pkgs, lib, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      gaps = {
        inner = 6;
        outer = 3;
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
        in
        lib.mkOptionDefault {
          "${modifier}+Return" = "exec --no-startup-id ${pkgs.alacritty}/bin/alacritty";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "floating toggle";
          "${modifier}+d" = ''
            exec --no-startup-id "${pkgs.rofi}/bin/rofi -modi drun,run -show drun -config ~/.config/rofi/rofidmenu.rasi"'';
          "${modifier}+Shift+d" = ''
            exec --no-startup-id "${pkgs.rofi}/bin/rofi -show window -config ~/.config/rofi/rofidmenu.rasi"'';

          "Alt+Tab" = ''
            exec --no-startup-id "${pkgs.rofi}/bin/rofi -show window -config ~/.config/rofi/rofidmenu.rasi"'';

          "${modifier}+Shift+e" = "exec --no-startup-id ~/.config/i3/scripts/powermenu";
          # Can also add -p ~/Pictures/screenshots
          "Print" = ''exec --no-startup-id "flameshot gui -p ~/Pictures/screenshots"''; # Print selection
          "Shift+Print" = ''exec --no-startup-id "flameshot screen -p ~/Pictures/screenshots"''; # Print cursor screen
          "Ctrl+Shift+Print" = ''exec --no-startup-id "flameshot full -p ~/Pictures/screenshots"''; # Print all monitors
          "${modifier}+v" = "exec --no-startup-id copyq toggle";
          "${modifier}+Shift+v" = "exec --no-startup-id copyq toggle";
          "${modifier}+b" = "split h";
          "${modifier}+n" = "split v";

        };
      floating = { criteria = [{ title = "CopyQ"; }]; };
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
        {
          command = "${pkgs.copyq}/bin/copyq";
          always = true;
          notification = false;
        }
        {
          command = "--no-startup-id code";
          always = true;
        }
        {
          command = "--no-startup-id alacritty";
          always = true;
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
