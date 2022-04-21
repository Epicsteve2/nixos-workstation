# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:
{
  imports = [
    # <home-manager/nixos>
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # nur-no-pkgs.repos.kira-bruneau.modules.lightdm-webkit2-greeter
  ];
  # nixpkgs.config.allowBroken = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader = {
    # # Use the systemd-boot EFI boot loader.
    # probably VM's only
    # systemd-boot.consoleMode = "max";
    # systemd-boot.editor = false;
    # systemd-boot.enable = false; # default
    #efi.canTouchEfiVariables = true; # default
    timeout = 10;
    grub = {
      device = "/dev/vda";
      version = 2;
      enable = true;
      default = "saved";
      #efiSupport = true;
      #efiInstallAsRemovable = true; # idk what this does lol
      #gfxmodeEfi = "1920x1080";
      gfxmodeBios = "1920x1080";
      # fixed cuz https://github.com/chickazee4/mynix
      #theme = "/boot/grub/themes/Nakano_Miku/Miku";
      # extraConfig = "set theme=${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze/theme.txt";

      #extraConfig = "set theme='/home/stephen/code-monkey/nixos-workstation/GRUB-Theme/Nakano Miku/Miku/theme.txt'";
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
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;
  environment.variables = rec {
    BROWSER = "firefox";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "konsole";
  };
  networking.hostName = "SteveNixOS"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Canada/Eastern";

  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.networkmanager.enable = true;

  environment.shells = with pkgs; [ zsh ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "FiraCode Nerd Font";
    keyMap = "us";
  };

  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "Monofur" "Meslo" ]; }) ];

  services.xserver = {
    displayManager = {
      sddm.enable = true;
      setupCommands = ''${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080'';
    };
    enable = true;
    layout = "us";

    desktopManager.plasma5 = {
      enable = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stephen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    home = "/home/stephen";
    password = "dt";
    shell = pkgs.zsh;
  };

  users.users.hm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    home = "/home/hm";
    password = "dt";
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
  users.defaultUserShell = pkgs.zsh;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    flameshot
    moreutils
    # haskellPackages.kmonad
    mimeo

    neovim
    nano
    onefetch

    zathura

    xorg.xkill
    lxappearance # Program that manages themeing
    networkmanagerapplet # GUI for networking
    dconf
    gparted
    thefuck
    dex
    peek
    networkmanager

    # yt-dlp
    # gimp
    # obs-studio
    # ffmpeg
    # noto-fonts-cjk
    # xdotool
    # discord
    # gnome.seahorse
    xdg-user-dirs
    dua
    ncdu

    rnix-lsp # language server for nix
    zsh
    git
    zip
    cht-sh
    feh
    wget
    unzip
    unrar
    sxiv
    gnumake
    exa
    htop
    neofetch
    ripgrep
    fd
    bat
    fzf
    nixfmt

    xorg.xev
    font-manager
    gnome.gnome-font-viewer
    copyq
    firefox

    breeze-qt5 # Breeze theme for qt5 (cursors!)

    kalker
    nodePackages.insect

    tealdeer
    alacritty
    #vscode
    du-dust
    home-manager
    # ulauncher
    delta
    duf
    bottom
    gping
    cached-nix-shell #

    sysz
    cinnamon.bulky
    vscode

    procs
    xclip
    mpv
    any-nix-shell
    killall
    nomacs
    qview
    cinnamon.nemo
    hexyl
    xfce.thunar
    neovide
    pcmanfm
    qpdfview
    brave
    okular
    strawberry
    qbittorrent
    # grub2
    starship
    micro
    gnupg
    sublime4
    terminator
    wezterm
    zoxide
    macchina
    navi
    freshfetch
    nitrogen
    fsearch
    ranger
    lf
  ];

  # source https://discourse.nixos.org/t/ulauncher-and-the-debugging-journey/13141/5
  # systemd.user.services.ulauncher = {
  #   enable = true;
  #   description = "Start Ulauncher";
  #   script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";

  #   documentation = [
  #     "https://github.com/Ulauncher/Ulauncher/blob/f0905b9a9cabb342f9c29d0e9efd3ba4d0fa456e/contrib/systemd/ulauncher.service"
  #   ];
  #   wantedBy = [ "graphical.target" "multi-user.target" ];
  #   after = [ "display-manager.service" ];
  # };

  programs = {
    zsh = {
      enable = true;
    };
  };

  system.stateVersion = "unstable"; # Did you read the comment?
}
