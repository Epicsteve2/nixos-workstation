# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [ # Include the results of the hardware scan.
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  boot.loader = {
    # # Use the systemd-boot EFI boot loader.
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 10;
    grub = {
      # grub isn't used
      # device = "nodev";
      # version = 2;
      # enable = true;
      # this only works cuz 
      # timeout = 10;
      default = "saved";
      gfxmodeEfi = "1920x1080";
      gfxmodeBios = "1920x1080";
      # font = "Meslo LGS Nerd Font";
      #    theme = pkgs.nixos-grub2-theme;
      #    extraConfig = "set theme=${pkgs.plasma5.breeze-grub}/grub/themes/breeze/theme.txt";

      extraConfig =
        "set theme='/home/stephen/code-monkey/nixos-workstation/GRUB-Theme/Nakano Miku/Miku/theme.txt'";

    };
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
    font = "FiraCode";
    keyMap = "us";
  };

  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "Monofur" "Meslo" ]; }) ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # # services.xserver.displayManager.gdm.enable = true;

  # # services.xserver.desktopManager.gnome.enable = true;
  # virtualisation.virtualbox.guest.enable = true;
  # # services.xserver.desktopManager.lxqt.enable = true;
  # # services.xserver.desktopManager.cinnamon.enable = true;
  # # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "stephen";
  # # services.xserver.windowManager.leftwm.enable = true;
  # services.xserver.windowManager.leftwm.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    # desktopManager = {
    #   default = "xfce";
    #   xterm.enable = false;
    #   xfce = {
    #     enable = true;
    #     noDesktop = true;
    #     enableXfwm = false;
    #   };
    # };
    # windowManager.i3.enable = true;

    displayManager = {
      #setupCommands = "xrandr --output Virtual1 --mode 1920x1080";
      lightdm = {
        enable = true;
        # greeters.enso.enable = true;
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.arc-theme;
            name = "Arc-Dark";
          };
          iconTheme = {
            package = pkgs.arc-icon-theme;
            name = "Arc";
          };
        };
        background = builtins.fetchurl {
          url = "https://i.imgur.com/QLntV2f.jpg";
        };
        #background = pkgs.fetchurl {
        #   url =
        #    "https://raw.githubusercontent.com/mbprtpmix/nixos/testing/wallpapers/mountains.jpg";
        #    sha256 = "0k7lpj7rlb08bwq3wy9sbbq44rml55jyp9iy4ipwzy4bch0mc6y4";
        #};

        #greeters.gtk = {
        #  theme.name = "Sweet-Dark";
        #  iconTheme.name = "Arc";
        #  cursorTheme.name = "Capitaine Cursors";
        #  clock-format = "%H:%M";
        #  indicators = [ "~clock" "~spacer" "~host" "~spacer" "~power" ];
        #  extraConfig = ''
        #    font-name = Unifont 12
        #  '';
        # };

      };
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "stephen";
      };
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
    arc-icon-theme
    arc-theme
    meslo-lgs-nf

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
    mpv
    any-nix-shell
    killall
    xorg.xev
    nomacs
    qview
    cinnamon.nemo
    xfce.thunar
    qpdfview
    brave
    okular
    strawberry
    qbittorrent
    grub2
    starship
    micro
    sublime4
    terminator
    wezterm
    zoxide
    macchina
    freshfetch
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

  programs.home-manager.enable = true;
  programs = {
    gpg.enable = true;
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
