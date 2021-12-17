{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    # Should do
    #userSettings = builtins.fromJSON (builtins.readFile ./settings.json);

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
      "nix.enableLanguageServer" = true;
      "path-autocomplete.triggerOutsideStrings" = true;
    };
    # extensions = with pkgs.vscode-extensions; [
    #   usernamehw.errorlens
    #   dcasella.i3
    #   brettm12345.nixfmt-vscode
    #   esbenp.prettier-vscode
    #   pkief.material-icon-theme
    #   bungcip.better-toml
    #   yzhang.markdown-all-in-one
    #   aaron-bond.better-comments
    #   alefragnani.Bookmarks
    #   eamodio.gitlens
    #   foxundermoon.shell-format
    #   kruemelkatze.vscode-dashboard
    #   mads-hartmann.bash-ide-vscode
    #   naumovs.color-highlight
    #   timonwong.shellcheck
    #   formulahendry.auto-close-tag
    #   formulahendry.auto-rename-tag
    #   donjayamanne.githistory
    #   johnpapa.vscode-peacock
    #   ibm.output-colorizer
    #   streetsidesoftware.code-spell-checker
    #   ionutvmi.path-autocomplete
    # ];

  };
}
