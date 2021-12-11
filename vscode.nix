{ pkgs, lib, ... }:

{
  programs.vscode = {
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
      # "editor.wordSeparators" =
      #   ''`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?''; # no dash
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
}