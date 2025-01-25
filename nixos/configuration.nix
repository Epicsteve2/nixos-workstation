# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
# let 
#   unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
# in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
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

  fonts.packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

  environment.systemPackages = with pkgs; [
    spice-vdagent # just for VM's
    nodejs
    python3
    # nil
    # xorg.xrandr # just for sddm
    # unstable.neovim
    neovim
    chezmoi
    rustup
    alacritty
    gcc
    tmux
    fzf
    zsh
    ripgrep
    tealdeer
    git
    fastfetch
    dua
    duf
    fd
    eza
    htop
    bottom
    bat
    delta
    gping
    starship
    zoxide
    unzip
    atuin
    lazygit
    gitui
    nixfmt-classic
    wget
    libnotify
    atuin
    yazi
    # trashy
    just
    gtrash

    # # other programs that may be useless in VMs 
    yt-dlp
    # obs 
    # gimp 
    peek
    onefetch
    copyq
    megasync
    # qalculate
    # # dust
    # # sysz
    kondo
    vscode
    mpv
    # nomacs 
    # # hexyl
    # qpdfview 
    qbittorrent
    strawberry
    # systemctl-tui
    bruno
    # noisetorch # maybe there's an alt?
    # micro 
    vlc
    # helix 
    # antimicrox 
    # audacity 
    discord
    # steam
    # # bpython
    chromium
    droidcam
    # dolphin-emu 
    # jdownloader
    # kdenlive 
    # kdePackages.kmousetool 
    libreoffice
    # lutris
    wine
    winetricks
    protontricks
    protonup-qt
    # retroarch 
    scrcpy
    thunderbird
    # telegram-desktop 
    # wireshark 
    # zoom-us 
    virt-manager
    docker
    go-task
    # trashy 
    distrobox
    # # flatpak 
    # # snap # not supported!!
    kanata
    miniserve
    eget
    # inlyne # idk maybe not good
  ];

  programs.kdeconnect.enable = true;
  # services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bootloader.
  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-uuid/db22b842-8a31-446a-8d2e-2fe8dc661516";
    # device = "/dev/sdx1";
    useOSProber = false;
    efiSupport = true;
    default = "saved";
    # gfxmodeBios = "1920x1080";
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
      # I found this in the arch wiki, but i don't think my grub will have this lol
      # menuentry "UEFI Shell" {
      #   insmod fat
      #   insmod chain
      #   search --no-floppy --set=root --file /shellx64.efi
      #   chainloader /shellx64.efi
      # }
    '';
  };

  networking.hostName = "stephen";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.enable = false;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # doesn't work, so idc
  # services.xserver.displayManager.setupCommands =
  #   "${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # # i don't think this really works in VM's
  # services.xserver.xrandrHeads = [{
  #   output = "Virtual-1";
  #   primary = true;
  #   monitorConfig = "DisplaySize 1920 1080";
  # }];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # for dynamically linked libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;
    [

    ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stephen = {
    isNormalUser = true;
    description = "stephen";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirt" "uinput" ];
    packages = with pkgs;
      [
        kdePackages.kate
        # thunderbird
      ];
  };

  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "stephen";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
