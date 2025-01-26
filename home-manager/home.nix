# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # <plasma-manager/modules>
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  programs.plasma = {
    enable = true;
    hotkeys.commands."launch-alacritty" = {
      name = "Launch Konsole";
      key = "Meta+T";
      command = "alacritty";
    };
  };

  nixpkgs = {
    # You can add overlays here
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
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };
  # [Unit]
  # Description=Kanata keyboard remapper
  # Documentation=https://github.com/jtroo/kanata
  #
  # [Service]
  # ; Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin
  # Environment=DISPLAY=:0
  # Environment=HOME=/home/stephen
  # Type=simple
  # ExecStart=/run/current-system/sw/bin/kanata --cfg /home/stephen/.config/kanata/asus-laptop.kbd
  # Restart=never
  # 
  # [Install]
  # WantedBy=default.target
  systemd = {
    user = {
      services = {
        kanata = {
          Unit = {
            Description = "Kanata keyboard remapper";
            Documentation = "https://github.com/jtroo/kanata";
          };
          Service = {
            Environment = "DISPLAY=:0";
            # Environment=HOME=/home/stephen
            # Type=simple
            ExecStart =
              "/run/current-system/sw/bin/kanata --cfg /home/stephen/.config/kanata/asus-laptop.kbd";

          };
          Install = { WantedBy = [ "default.target" ]; };
        };

        fusuma = {
          Unit = { Description = "Touchpad gestures"; };
          Service = {
            # Environment = "DISPLAY=:0";
            # Environment=HOME=/home/stephen
            # Type=simple
            ExecStart = "/run/current-system/sw/bin/fusuma";

          };
          Install = { WantedBy = [ "default.target" ]; };
        };
      };
    };
    # stephen = {
    #   services = [
    #
    # ]
    # }
  };

  # TODO: Set your username
  home = {
    username = "stephen";
    homeDirectory = "/home/stephen";
  };

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
