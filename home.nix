{ config, pkgs, lib, ... }:

{
  imports = [ ./polybar.nix ./rofi.nix ./i3.nix ];
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
        # "editor.formatOnPaste" = true;
        "editor.formatOnType" = true;
        "workbench.colorTheme" = "Monokai";
        "explorer.sortOrder" = "modified";
        "workbench.editor.highlightModifiedTabs" = true;
        "terminal.integrated.cursorStyle" = "line";
        "terminal.integrated.fontFamily" = "MesloLGS Nerd Font";
        "editor.fontLigatures" = true;
        "workbench.sideBar.location" = "right";
        "editor.cursorSmoothCaretAnimation" = true;
        "editor.cursorBlinking" = "phase";
        "editor.smoothScrolling" = true;
        "workbench.list.smoothScrolling" = true;
        "editor.scrollBeyondLastLine" = false;
        "workbench.editor.enablePreview" = false;
        "editor.minimap.renderCharacters" = false;
        "editor.wordSeparators" =
          ''`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?''; # no dash
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
        working_directory = "/home/stephen/code-monkey/nixos-workstation";
        background_opacity = 0.86;
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
  };
  xsession.enable = true;
  

  services.picom = {
    enable = true;
    # package = pkgs.callPackage ../packages/compton-unstable.nix { };
    # experimentalBackends = true;

    blur = true;
    blurExclude = [ "window_type = 'dock'" "window_type = 'desktop'" ];

    fade = true;
    fadeDelta = 5;

    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = "0.7";
    shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
    noDockShadow = true;
    noDNDShadow = true;

    activeOpacity = "1.0";
    inactiveOpacity = "0.8";
    menuOpacity = "0.8";

    backend = "glx";
    vSync = true;

    extraOptions = ''
      shadow-radius = 7;
      clear-shadow = true;
      frame-opacity = 0.7;
      blur-method = "dual_kawase";
      blur-strength = 5;
      alpha-step = 0.06;
      detect-client-opacity = true;
      detect-rounded-corners = true;
      paint-on-overlay = true;
      detect-transient = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
    '';
  };
}
