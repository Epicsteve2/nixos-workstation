{
  config,
  pkgs,
  pkgs-24-11,
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
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
  nixpkgs = {
    overlays = [ outputs.overlays.unstable-packages ];
    config.allowUnfree = true;
  };
  services.libinput = {
    enable = true;
    touchpad = {
      disableWhileTyping = true;
    };
  };

  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;
  programs.nix-ld.enable = true; # for dynamically linked libraries
  # chrome dependencies
  # created by running nix-alien-ld --flake /home/stephen/.cache/puppeteer/chrome/linux-137.0.7151.55/chrome-linux64/chrome
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib.out
    at-spi2-atk.out
    cairo.out
    cups.lib
    dbus.lib
    glib.out
    libgbm.out
    libxkbcommon.out
    nspr.out
    nss.out
    pango.out
    systemd.out
    xorg.libX11.out
    xorg.libXcomposite.out
    xorg.libXdamage.out
    xorg.libXfixes.out
    xorg.libXrandr.out
    xorg.libxcb.out
    xorg_sys_opengl.out
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.libvirtd.enable = true; # todo https://nixos.wiki/wiki/Virt-manager
  virtualisation.spiceUSBRedirection.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;
  programs.neovim = {
    defaultEditor = true;
    enable = true;
  };
  programs.obs-studio.enable = true;
  programs.git.enable = true;
  programs.lazygit.enable = true;
  programs.htop.enable = true;
  programs.starship.enable = true;
  programs.tmux.enable = true;
  programs.yazi.enable = true;
  programs.chromium.enable = true; # need to add in systemPackages too
  programs.droidcam.enable = true;
  programs.steam.protontricks.enable = true;
  programs.thunderbird.enable = true;
  programs.virt-manager.enable = true;
  programs.adb.enable = true;
  # programs.steam.enable = true;
  # programs.wireshark.enable = true;
  # programs.noisetorch.enable
  programs.ydotool.enable = true;
  programs.direnv.enable = true;
  # services.openssh.enable = true;
  # services.flatpak.enable = true;
  services.kanata.enable = true;
  services.kanata.package = pkgs.kanata-with-cmd;
  xdg.portal.enable = true;
  services.nixos-cli = {
    enable = true;
    config = {
    };
  };

  environment.variables = {
    BROWSER = "firefox";
    MOZ_USE_XINPUT2 = 1; # for pinch to zoom and smooth scrolling
  };
  environment.systemPackages = with pkgs; [
    ## Languages and development
    act
    (azure-cli.withExtensions [ azure-cli.extensions.containerapp ])
    cargo
    dive
    unstable.code-cursor
    gcc
    go
    kdePackages.kate
    libqalculate
    unstable.neovim
    nixfmt-rfc-style
    inputs.nix-alien.packages.${pkgs.system}.nix-alien
    inputs.inputactions.packages.${pkgs.system}.inputactions-kwin
    nodejs
    pnpm
    python3
    python312Packages.bpython
    rustc
    terraform
    # texlive.combined.scheme-full
    typst
    unstable.vscode

    ## CLI
    alacritty
    atuin
    bat
    bottom
    chezmoi
    clipse
    comma
    delta
    distrobox
    dua
    duf
    eget
    eza
    fastfetch
    fd
    ffmpeg-full
    fusuma
    fzf
    gh
    gitui
    go-task
    gping
    gtrash
    helix
    hexyl
    inlyne
    jq
    just
    kanata-with-cmd
    kdePackages.ksshaskpass
    kondo
    lazydocker
    libnotify
    miniserve
    nh
    onefetch
    ripgrep
    systemctl-tui
    sysz
    tealdeer
    unstable.quickemu
    unstable.zellij
    unzip
    wget
    wl-clipboard
    wmctrl # needed for zsh-notify
    xdotool # needed for zsh-notify
    yt-dlp
    zip
    zoxide
    # xclip

    ## Desktop
    audacity
    bruno
    chromium
    copyq
    discord
    gimp
    libreoffice
    megasync
    mpv
    nomacs
    peek
    protonup-qt
    qbittorrent
    qpdfview
    scrcpy
    slack
    strawberry
    unstable.dbeaver-bin
    vlc
    wine
    winetricks
    xdg-user-dirs
    zoom-us
    # jdownloader # doesn't exist
    # kdePackages.kdenlive
    # kdePackages.kmousetool
    # antimicrox
    # lutris
    # dust
    ## for vim
    # retroarch # there's also services.xserver.desktopManager.retroarch.enable
    # telegram-desktop
    # wireshark
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = ${inputs.sddm-wallpaper}
    '')
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
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
  networking.firewall.enable = false;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      wayland.enable = true;
      enable = lib.mkDefault true;
      theme = "breeze";
      autoNumlock = false;
    };
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  users.defaultUserShell = pkgs.fish;
  users.users.stephen = {
    isNormalUser = true;
    useDefaultShell = false;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "uinput"
      "input"
      "adbusers"
      "ydotool"
    ];
    packages = with pkgs; [ ];
  };
  # users.users.test3 = {
  #   isNormalUser = true;
  #   extraGroups = [
  #     "networkmanager"
  #     "wheel"
  #     "docker"
  #     "libvirtd"
  #     "uinput"
  #     "input"
  #     "adbusers"
  #     "ydotool"
  #   ];
  #   password = "h";
  # };

  security.sudo.extraConfig = ''
    Defaults timestamp_type=global
  '';
  ## temp
  security.sudo.wheelNeedsPassword = false;

  ## to add on desktop PC
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "stephen";

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
