# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  boot.loader = {
    # # Use the systemd-boot EFI boot loader.
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    timeout = 10;
    grub = {
      # grub isn't used
      # device = "nodev";
      devices = [ "nodev" ];
      version = 2;
      enable = true;
      # this only works cuz 
      # timeout = 10;
      default = "saved";
      efiSupport = true;
      efiInstallAsRemovable = true;
      gfxmodeEfi = "1920x1080";
      gfxmodeBios = "1920x1080";
      # font = "Meslo LGS Nerd Font";
      #    theme = pkgs.nixos-grub2-theme;
      #  extraConfig = "set theme=${pkgs.plasma5.breeze-grub}/grub/themes/breeze/theme.txt";

      extraConfig =
        "set theme='/home/stephen/code-monkey/nixos-workstation/GRUB-Theme/Nakano Miku/Miku/theme.txt'";
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';

    };
  };
  environment.variables = rec {
    BROWSER = "brave";
    EDITOR = "spacevim";
    VISUAL = "spacevim";
    TERMINAL = "alacritty";
  };
  networking.hostName = "SteveNixOS"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Canada/Eastern";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  environment.shells = with pkgs; [ zsh ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "FiraCode Nerd Font";
    keyMap = "us";
  };

  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "Monofur" "Meslo" ]; }) ];

  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme.name = "Sweet-Dark";
          theme.package = pkgs.sweet;
          iconTheme.name = "Arc";
          iconTheme.package = pkgs.arc-icon-theme;
          # Really weird bug? idk man
          extraConfig = "";
        };
        background =
          builtins.fetchurl { url = "https://i.imgur.com/QLntV2f.jpg"; };
        # So close! doesn't work tho
        # greeter.package = pkgs.nur.repos.kira-bruneau.lightdm-webkit2-greeter;
        # greeter.name = "lightdm-webkit2-greeter-2.2.5";
      };
      defaultSession = "none+i3";
      # autoLogin = {
      #   enable = true;
      #   user = "stephen";
      # };
    };

    desktopManager = {
      cinnamon.enable = true;
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        rofi
        i3status # gives you the default i3 status bar
        polybar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stephen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/stephen";
    password = "";
    shell = pkgs.zsh;
  };

  users.users.hm2 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/hm2";
    password = "";
    shell = pkgs.zsh;
  };

  # home-manager.users.hm = { pkgs, ... }: {
  #   # home.packages = [ pkgs.atool pkgs.httpie ];
  #   shell = pkgs.zsh;
  # };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  # users.users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  #   $ nix search wget
  environment.systemPackages = with pkgs; [
    # arc-icon-theme
    # arc-theme
    # meslo-lgs-nf

    # nur.repos.kira-bruneau.lightdm-webkit2-greeter

    neovim
    spacevim
    nano
    xorg.xkill
    wget
    firefox
    zsh
    git
    zip
    gparted
    unzip
    gnumake
    exa
    htop
    neofetch
    ripgrep
    fd
    bat
    fzf
    alacritty
    tealdeer
    vscode
    nixfmt
    du-dust
    home-manager
    ulauncher
    delta
    duf
    bottom
    gping
    procs
    xclip
    copyq
    font-manager
    mpv
    any-nix-shell
    killall
    xorg.xev
    nomacs
    qview
    cinnamon.nemo
    hexyl
    xfce.thunar
    qpdfview
    brave
    okular
    strawberry
    qbittorrent
    grub2
    starship
    micro
    gnupg
    sublime4-dev
    terminator
    wezterm
    zoxide
    macchina
    freshfetch
    nitrogen
    ranger
  ];

  # source https://discourse.nixos.org/t/ulauncher-and-the-debugging-journey/13141/5
  systemd.user.services.ulauncher = {
    enable = true;
    description = "Start Ulauncher";
    script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";

    documentation = [
      "https://github.com/Ulauncher/Ulauncher/blob/f0905b9a9cabb342f9c29d0e9efd3ba4d0fa456e/contrib/systemd/ulauncher.service"
    ];
    wantedBy = [ "graphical.target" "multi-user.target" ];
    after = [ "display-manager.service" ];
  };

  programs = {
    # gpg.enable = true;
    # exa.enable = true;
    # fzf.enable = true;
    # home-manager.enable = true;
    # zoxide.enable = true;
    htop = {
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
  };

  programs.nano.nanorc = ''
    set constantshow
    set linenumbers
    set mouse
    # set smooth
    set indicator
    set smarthome
    set autoindent

    set titlecolor bold,lightwhite,blue
    set promptcolor lightwhite,lightblack
    set statuscolor bold,lightwhite,green
    set errorcolor bold,lightwhite,red
    set spotlightcolor black,lime
    set selectedcolor lightwhite,magenta
    set stripecolor ,yellow
    set scrollercolor cyan
    set numbercolor cyan
    set keycolor cyan
    set functioncolor green

    bind ^Q exit all
    bind ^S savefile main
    bind ^W writeout main
    bind ^O insert main
    bind ^H help all
    bind ^H exit help
    bind ^F whereis all
    bind ^G findnext all
    bind ^B wherewas all
    bind ^D findprevious all
    bind ^R replace main
    bind ^X cut main
    bind ^C copy main
    bind ^V paste all
    bind ^P location main
    bind ^E execute main
    bind ^A mark main
    unbind ^K main
    unbind ^U all
    unbind ^N main
    unbind ^Y all
    unbind M-J main
    unbind M-T main
    bind ^T gotoline main
    bind ^T gotodir browser
    bind ^T cutrestoffile execute
    bind ^L linter execute
    bind M-U undo main
    bind M-R redo main
    bind ^Z undo main
    bind ^Y redo main
    set multibuffer
  '';

  system.stateVersion = "unstable"; # Did you read the comment?
}
