{ config, pkgs, lib, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  # for dynamically linked libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;
  xdg.portal.enable = true;
  # programs.ydotool.enable = true;
  # services.openssh.enable = true;
  # services.flatpak.enable = true;
  services.kanata.enable = true;
  services.kanata.package = pkgs.kanata-with-cmd;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };
  environment.systemPackages = with pkgs; [
    ## Languages and development
    cargo
    gcc
    go
    libqalculate
    neovim
    nixfmt-classic
    nodejs
    obs-studio
    pnpm
    python3
    rustc
    terraform
    vscode

    ## CLI
    alacritty
    atuin
    bat
    bottom
    chezmoi
    comma
    delta
    distrobox
    dua
    duf
    eget
    eza
    fastfetch
    fd
    ffmpeg
    # ffmpeg-full
    fusuma
    fzf
    git
    gitui
    go-task
    gping
    gtrash
    htop
    just
    kdePackages.ksshaskpass
    kondo
    lazydocker
    lazygit
    libnotify
    miniserve
    onefetch
    ripgrep
    starship
    tealdeer
    tmux
    unzip
    wget
    wmctrl
    xclip
    xdotool
    yazi
    yt-dlp
    zoxide

    ## Desktop
    bruno
    chromium
    copyq
    discord
    droidcam
    gimp
    libreoffice
    megasync
    mpv
    peek
    protontricks
    protonup-qt
    qbittorrent
    scrcpy
    slack
    strawberry
    thunderbird
    virt-manager
    vlc
    wine
    winetricks
    # jdownloader # doesn't exist
    # kdenlive 
    # kdePackages.kmousetool 
    # dust
    # sysz
    # nomacs 
    # # hexyl
    # qpdfview 
    # systemctl-tui
    # noisetorch # maybe there's an alt?
    # helix 
    # antimicrox 
    # audacity 
    # steam
    # # bpython
    # lutris
    ## for vim
    # wl-clipboard
    # retroarch 
    # telegram-desktop 
    # wireshark 
    # zoom-us 
    # flatpak 
    # inlyne # idk maybe not good
  ];

  nixpkgs.config.allowUnfree = true;
  users.defaultUserShell = pkgs.fish;

  # this should go in hardware-configuration?
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-uuid/db22b842-8a31-446a-8d2e-2fe8dc661516";
    useOSProber = false;
    efiSupport = true;
    default = "saved";
    gfxmodeBios = "1920x1080";
    extraEntries = ''
      menuentry "Reboot" {
        reboot
      }
      menuentry "Poweroff" {
        halt
      }
      if [ ''${grub_platform} == "efi" ]; then
        menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
          fwsetup
        }
      fi
    '';
  };

  networking.hostName = "asus-vivobook";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasmax11";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  users.users.stephen = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirt"
      "uinput"
      "input"
      # "ydotool"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };
  users.users.test = {
    isNormalUser = true;
    extraGroups =
      [ "networkmanager" "wheel" "docker" "libvirt" "uinput" "input" ];
    password = "h";
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_type=global
  '';
  ## temp
  security.sudo.wheelNeedsPassword = false;

  ## to add on desktop PC
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "stephen";

  ## Some programs need SUID wrappers, can be configured further or are
  ## started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";

}
