# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:
let
  nur-no-pkgs = import
    (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz")
    { };
in
{
  imports = [
    # <home-manager/nixos>
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    nur-no-pkgs.repos.kira-bruneau.modules.lightdm-webkit2-greeter
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import
      (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz")
      {
        inherit pkgs;
      };
  };
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
  services.xserver.videoDrivers = [ "qxl" ];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  environment.variables = rec {
    BROWSER = "firefox";
    EDITOR = "spacevim";
    VISUAL = "spacevim";
    TERMINAL = "alacritty";
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
    font = "FiraCode Nerd Font";
    keyMap = "us";
  };

  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "FiraCode" "Monofur" "Meslo" ]; }) ];

  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = {
      # lightdm = {
      #   enable = true;
      #   # greeters.gtk = {
      #   #   enable = true;
      #   #   theme.name = "Sweet-Dark";
      #   #   theme.package = pkgs.sweet;
      #   #   iconTheme.name = "Arc";
      #   #   iconTheme.package = pkgs.arc-icon-theme;
      #   #   # Really weird bug? idk man
      #   #   extraConfig = "";
      #   # };
      #   # background =
      #   #   builtins.fetchurl { url = "https://i.imgur.com/QLntV2f.jpg"; };
      # };

      lightdm = {
        enable = true;
        greeters.webkit2 = {
          enable = true;
          # webkitTheme = pkgs.fetchFromGitHub {
          #   owner = "NoiSek";
          #   repo = "Aether";
          #   rev = "76802308e1f64cffa1d0d392a0f953e99a797496";
          #   sha256 = "1w5w15py5rbrw1ad24din7kwcjz82mh625d7b4r7i8kzb9knl7d6";
          # };
          webkitTheme =
            pkgs.nur.repos.kira-bruneau.themes.lightdm-webkit2-greeter.litarvan;
        };
      };

      # https://framagit.org/MarianArlt/sddm-sugar-candy
      setupCommands = ''${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080'';
      # sddm = {
      #   enable = true;
      #   autoNumlock = true;

      #   theme = "sugar-candy";
      #   # theme = "clairvoyance";
      #   # theme = "minimal-sddm-theme";
      #   # theme = "sddm-chili";

      #   # settings = {
      #   #   General = {
      #   #     Background = "/usr/share/backgrounds/1172141.png";
      #   #   };
      #   #   # Theme = {
      #   #   #   ScreenWidth = 1920;
      #   #   # ScreenHeight = 1080;
      #   #   # FormPosition = "right";
      #   #   # };
      #   # };
      # };

      defaultSession = "none+i3";
      autoLogin = {
        enable = false;
        user = "stephen";
      };
    };

    desktopManager.cinnamon = {
      enable = true;
    };
    windowManager.i3 = { enable = true; };
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
    numlockx
    picom-next
    i3-gaps
    dunst
    rofi
    polybar
    libnotify
    flameshot
    sxhkd
    moreutils
    pamixer
    playerctl
    rofimoji
    rofi-calc
    # haskellPackages.kmonad
    mimeo
    papirus-icon-theme
    #gnome3.gnome_themes_standard

    
    qemu-utils
    spice-vdagent
    xorg.xf86videoqxl

    neovim
    spacevim
    nano

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
    gnome.seahorse
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

    # Broken package apparently
    # haskellPackages.kmonad
    breeze-qt5 # Breeze theme for qt5 (cursors!)

    #nur.repos.kira-bruneau.themes.sddm.clairvoyance
    #nur.repos.suhr.minimal-sddm-theme
    #nur.repos.dan4ik605743.sddm-chili
    #SDDM
    # libsForQt5.qt5.qtgraphicaleffects
    # nur.repos.alarsyo.sddm-sugar-candy

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
    htop = {
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };
    # qt5ct.enable = true;
    zsh = {
      enable = true;
      # shellInit = ''
      #   ## Added by Zinit's installer
      #   if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
      #       print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
      #       command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
      #       command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
      #           print -P "%F{33} %F{34}Installation successful.%f%b" || \
      #           print -P "%F{160} The clone has failed.%f%b"
      #   fi

      #   source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
      #   autoload -Uz _zinit
      #   (( ''${+_comps} )) && _comps[zinit]=_zinit
      #   ### End of Zinit's installer chunk

      #   # Auto install starship
      #   # zinit ice as"command" from"gh-r" \
      #   #           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
      #   #           atpull"%atclone" src"init.zsh" # pull behavior same as clone, source init.zsh
      #   # zinit light starship/starship
      #   # zinit ice depth=1; zinit light romkatv/powerlevel10k
      #   eval $(starship init zsh)
      #   # based off of https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/termsupport.zsh
      #   zinit ice wait"0a" lucid; zinit light trystan2k/zsh-tab-title
      #   # zinit light 'chrissicool/zsh-256color' # idk what this does lol
      #   BASE16_THEME=monokai; zinit ice atload"base16_''${BASE16_THEME}"; zinit light "chriskempson/base16-shell"
      #   # zinit light ohmyzsh/ohmyzsh #Sucks on initial install
      #   zinit light zsh-users/zsh-syntax-highlighting
      #   zinit ice wait"0a" lucid atload'_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions
      #   # zinit ice depth=1 wait"1" lucid; zinit snippet OMZP::/zoxide
      #   eval "$(zoxide init zsh)"
      #   zinit snippet OMZP::fzf
      #   zinit ice wait"0c" lucid; zinit light Aloxaf/fzf-tab
      #   # idk if i should use this or any-nix-shell
      #   zinit ice wait"1" lucid; zinit light https://github.com/chisui/zsh-nix-shell
      #   # zinit ice wait"1" lucid; zinit snippet OMZ::plugins/thefuck

      #   # # Completions
      #   # zinit ice wait"1" lucid atload"zicompinit; zicdreplay" blockf; zinit light zsh-users/zsh-completions
      #   # zinit ice wait"1" lucid as"completion"; zinit snippet OMZP::docker-compose/_docker-compose
      #   # zinit ice wait"1" lucid as"completion"; zinit snippet OMZP::docker/_docker
      #   # zinit ice wait'1' lucid as"completion"; zinit snippet OMZP::terraform/_terraform
      #   # zinit ice wait"1" lucid atload"zicompinit; zicdreplay" blockf; zinit snippet OMZP::aws
      #   # zinit ice wait"1" lucid atload"zicompinit; zicdreplay" blockf; zinit snippet OMZP::kubectl
      #   # zinit ice wait"1" lucid as"completion"; zinit snippet OMZP::pip/_pip
      #   zinit ice wait"1" lucid as"completion"; zinit snippet https://github.com/alacritty/alacritty/releases/download/v0.9.0/_alacritty
      #   zinit ice wait"1" lucid; zinit light wfxr/forgit
      #   FORGIT_HELP=$(<<<'
      #   Command 	Option
      #   Enter 	Confirm
      #   Tab 	Toggle mark and move up
      #   Shift - Tab 	Toggle mark and move down
      #   ? 	Toggle preview window
      #   Alt - W 	Toggle preview wrap
      #   Ctrl - S 	Toggle sort
      #   Ctrl - R 	Toggle selection
      #   Ctrl - Y 	Copy commit hash*
      #   Ctrl - K / P 	Selection move up
      #   Ctrl - J / N 	Selection move down
      #   Alt - K / P 	Preview move up
      #   Alt - J / N 	Preview move down' | column -ts "$(printf '\t')") # instead of printf, can do $'\t'
      #   FORGIT_FZF_DEFAULT_OPTS="--reverse --header '''''${FORGIT_HELP}' --height '100%'"
      #   #https://git-scm.com/docs/git-log#Documentation/git-log.txt-emnem
      #   # %C = color
      #   # %h = short commit hash
      #   # %an = author
      #   # %d ref name (HEAD, origin)
      #   # %s subject / commit message
      #   # cr commit date, relative
      #   FORGIT_LOG_FORMAT='%C(auto)%h %C(green)%an%C(auto)%d %C(reset)%s %C(magenta)%C(bold)%cr%Creset'
      #   FORGIT_LOG_GRAPH_ENABLE=false
      #   FORGIT_GRAPH_ENABLE=false

      #   # Download a crap ton of programs
      #   if false; then
      #     # EXA
      #     zinit ice wait"2" lucid from"gh-r" as"program" mv"bin/exa* -> exa"; zinit light ogham/exa
      #     zinit ice wait blockf atpull'zinit creinstall -q .'
      #     # DELTA
      #     zinit ice lucid wait"0" as"program" from"gh-r" pick"delta*/delta"; zinit light 'dandavison/delta'
      #     # DUST
      #     zinit ice wait"2" lucid from"gh-r" as"program" mv"dust*/dust -> dust" pick"dust" atload"alias du=dust"; zinit light bootandy/dust
      #     # # DUF Only works in debian...
      #     # zinit ice lucid wait"0" as"program" from"gh-r" bpick='*linux_amd64.deb' pick"usr/bin/duf" atload"alias df=duf"; zinit light muesli/duf
      #     # BAT
      #     zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias bat=bat"; zinit light sharkdp/bat
      #     # RIPGREP
      #     zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"; zinit light BurntSushi/ripgrep
      #     # # FD
      #     # zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"; zinit light sharkdp/fd
      #     # FZF
      #     zinit ice from"gh-r" as"command"; zinit light junegunn/fzf
      #     zinit ice lucid wait'0c' multisrc"shell/{completion,key-bindings}.zsh" id-as"junegunn/fzf_completions" pick"/dev/null"; zinit light junegunn/fzf
      #     # RANGER
      #     zinit ice depth'1' as"program" pick"ranger.py"; zinit light ranger/ranger
      #   fi

      #   # Source https://github.com/junegunn/fzf/issues/477#issuecomment-631707533 {{{
      #   fzf-up-arrow-widget() {
      #     local extra_ctrl_r="--preview 'bat --color=always --plain --plain --language zsh <<<{}' --preview-window down:3:wrap"

      #     local selected num
      #     setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
      #     selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
      #       FZF_DEFAULT_OPTS="--height ''${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --header='tab to edit, enter to execute' --bind=ctrl-r:toggle-sort,ctrl-z:ignore --expect=tab $extra_ctrl_r --query=''${(qqq)LBUFFER} +m" $(__fzfcmd)) )
      #     local ret=$?
      #     if [ -n "$selected" ]; then
      #       local select=0
      #       if [[ $selected[1] == tab ]]; then
      #         select=1
      #         shift selected
      #       fi
      #       num=$selected[1]
      #       if [ -n "$num" ]; then
      #         zle vi-fetch-history -n $num
      #         [[ $select == 0 ]] && zle accept-line
      #       fi
      #     fi
      #     zle reset-prompt
      #     return $ret
      #   }
      #   zle -N fzf-up-arrow-widget fzf-up-arrow-widget
      #   bindkey "''${terminfo[kcuu1]}" fzf-up-arrow-widget
      #   bindkey "^[[A" fzf-up-arrow-widget
      #   bindkey '^R' fzf-up-arrow-widget
      #   # bindkey "''${key[Up]}" fzf-up-arrow-widget
      #   # }}}

      #   bindkey "^[[1;5C" forward-word
      #   bindkey "^[[1;5D" backward-word
      #   bindkey "\C-h" backward-kill-word
      #   bindkey "\e[3;5~" kill-word

      #   export BAT_PAGER='less --quit-if-one-screen --chop-long-lines --RAW-CONTROL-CHARS --LONG-PROMPT --ignore-case'
      #   export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
      #   export LS_COLORS='no=0:rs=0:di=01;38;5;198:ln=01;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:ex=01;38;5;82:*.cmd=00;38;5;82:*.exe=00;38;5;82:*.com=00;38;5;82:*.btm=00;38;5;82:*.bat=00;38;5;82:*.jpg=00;38;5;37:*.jpeg=00;38;5;37:*.png=00;38;5;37:*.gif=00;38;5;37:*.bmp=00;38;5;37:*.xbm=00;38;5;37:*.xpm=00;38;5;37:*.tif=00;38;5;37:*.tiff=00;38;5;37:*.pdf=00;38;5;98:*.odf=00;38;5;98:*.doc=00;38;5;98:*.ppt=00;38;5;98:*.pptx=00;38;5;98:*.db=00;38;5;98:*.aac=00;38;5;208:*.au=00;38;5;208:*.flac=00;38;5;208:*.mid=00;38;5;208:*.midi=00;38;5;208:*.mka=00;38;5;208:*.mp3=00;38;5;208:*.mpc=00;38;5;208:*.ogg=00;38;5;208:*.ra=00;38;5;208:*.wav=00;38;5;208:*.m4a=00;38;5;208:*.axa=00;38;5;208:*.oga=00;38;5;208:*.spx=00;38;5;208:*.xspf=00;38;5;208:*.mov=01;38;5;208:*.mpg=01;38;5;208:*.mpeg=01;38;5;208:*.3gp=01;38;5;208:*.m2v=01;38;5;208:*.mkv=01;38;5;208:*.ogm=01;38;5;208:*.mp4=01;38;5;208:*.m4v=01;38;5;208:*.mp4v=01;38;5;208:*.vob=01;38;5;208:*.qt=01;38;5;208:*.nuv=01;38;5;208:*.wmv=01;38;5;208:*.asf=01;38;5;208:*.rm=01;38;5;208:*.rmvb=01;38;5;208:*.flc=01;38;5;208:*.avi=01;38;5;208:*.fli=01;38;5;208:*.flv=01;38;5;208:*.gl=01;38;5;208:*.m2ts=01;38;5;208:*.divx=01;38;5;208:*.log=00;38;5;240:*.bak=00;38;5;240:*.aux=00;38;5;240:*.bbl=00;38;5;240:*.blg=00;38;5;240:*~=00;38;5;240:*#=00;38;5;240:*.part=00;38;5;240:*.incomplete=00;38;5;240:*.swp=00;38;5;240:*.tmp=00;38;5;240:*.temp=00;38;5;240:*.o=00;38;5;240:*.pyc=00;38;5;240:*.class=00;38;5;240:*.cache=00;38;5;240:';
      #   export EXA_COLORS="''${LS_COLORS}"
      #   export LSCOLORS=$LS_COLORS

      #   export EDITOR=spacevim
      #   export VISUAL=''${EDITOR}
      #   export PAGER='less --quit-if-one-screen --chop-long-lines --RAW-CONTROL-CHARS --LONG-PROMPT --ignore-case'
      #   export SHELL="$(which zsh)"

      #   export HISTFILE="''${HOME}/.zsh_history"
      #   export HISTSIZE=100000
      #   export SAVEHIST=$HISTSIZE

      #   # setopt BANG_HIST                 # Treat the '!' character specially during expansion.
      #   setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
      #   setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
      #   setopt SHARE_HISTORY             # Share history between all sessions.
      #   setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
      #   setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
      #   # setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
      #   setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
      #   # setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
      #   # setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
      #   setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
      #   setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

      #   zstyle ':completion:*:git-checkout:*' sort false
      #   # set list-colors to enable filename colorizing
      #   zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      #   # set descriptions format to enable group support
      #   zstyle ':completion:*:descriptions' format '[%d]'
      #   # case insensitive
      #   zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

      #   # preview directory's content with exa when completing cd
      #   zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
      #   zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${(P)word}'
      #   zstyle ':fzf-tab:*' fzf-bindings 'shift-tab:accept'
      #   zstyle ':fzf-tab:*' continuous-trigger 'tab'
      #   zstyle ':fzf-tab:*' accept-line enter
      #   # Disabled cuz bug where last element won't be shown cuz of header
      #   # zstyle ':fzf-tab:*' fzf-flags '--header="tab to continue completing, enter to execute, shift+tab to accept and edit, esc to cancel"'

      #   # https://github.com/DanielFGray/fzf-scripts/blob/master/igr {{{
      #   superrg () {
      #       declare preview='bat --color=always --style=header,numbers -H {2} {1} | grep -C3 {q}'

      #       while getopts ':l' x; do
      #         case "$x" in
      #           l) list_files=1
      #             preview='bat --color=always --style=header,numbers {1} | grep -C3 {q}'
      #             ;;
      #         esac
      #       done
      #       shift $(( OPTIND - 1 ))
      #       unset x OPTARG OPTIND

      #       rg --color=always -n ''${list_files:+-l} "$1" 2> /dev/null |
      #       fzf -d: \
      #       --ansi \
      #       --query="$1" \
      #       --phony \
      #       --bind="change:reload:rg -n ''${list_files:+-l} --color=always {q}" \
      #       --bind="enter:execute:''${EDITOR} {1}" \
      #       --preview="[[ -n {1} ]] && $preview"
      #   }
      #   # https://github.com/junegunn/fzf/wiki/Examples#man-pages
      #   # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      #   # idk what this does lol, completions???
      #   autoload bashcompinit && bashcompinit
      #   autoload -Uz compinit && compinit

      #   # cd when typing directory
      #   setopt autocd

      #   # when deleting word, stop at slash
      #   WORDCHARS='*?_-[]~\!#$%^(){}<>|`@#$%^*()+:?'

      #   # home and end
      #   bindkey  "^[[H"   beginning-of-line
      #   bindkey  "^[[F"   end-of-line

      #   alias ll='ls -hAlFv --group-directories-first --color=always'
      #   alias l='exa --long --icons --all --header --extended --git --group-directories-first --classify'
      #   alias bat="bat --number"
      #   alias cat="bat --plain --plain"
      #   alias fzfp="fzf --preview 'bat --color=always -pp --line-range=:500 {}'"
      #   alias r="source ranger"
      #   alias nix-shell="NIX_BUILD_SHELL=$(which zsh) nix-shell"
      #   alias vim="spacevim"
      #   alias vi="spacevim"
      #   alias nvim="spacevim"
      #   alias lfc="lfcd"

      #   # Expand only the g and k aliases
      #   # source https://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
      #   globalias() {
      #     EXPAND_ALIASES=(g k nix-shell vim nvim vi)
      #      if [[ ''${EXPAND_ALIASES[(ie)$LBUFFER]} -le ''${#EXPAND_ALIASES} ]]; then
      #        zle _expand_alias
      #        zle expand-word
      #      fi
      #      zle self-insert
      #   }
      #   zle -N globalias
      #   bindkey " " globalias
      #   source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

      #   lfcd () {
      #       tmp="$(mktemp)"
      #       lf -last-dir-path="$tmp" "$@"
      #       if [ -f "$tmp" ]; then
      #           dir="$(cat "$tmp")"
      #           rm -f "$tmp"
      #           if [ -d "$dir" ]; then
      #               if [ "$dir" != "$(pwd)" ]; then
      #                   cd "$dir"
      #               fi
      #           fi
      #       fi
      #   }
      # '';
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
