{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
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
  xsession.enable = true;
}
