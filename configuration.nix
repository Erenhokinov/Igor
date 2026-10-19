{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "mitigations=off"
    "nowatchdog"
    "processor.max_cstate=1"
    "noibrs"
    "noibpb"
    "nopti"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libvdpau-va-gl
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 64;
        default.clock.min-quantum = 64;
        default.clock.max-quantum = 64;
      };
    };
  };

  services.tlp.enable = false;
  services.thermald.enable = false;

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 60;
    swapDevices = 1;
    algorithm = "zstd";
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "16";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "pixman";
    LD_PRELOAD = "";
  };

  users.users."maks" = {
    isNormalUser = true;
    description = "maks";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "audio" "video" "input"];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      sansSerif = ["Inter"];
      monospace = ["JetBrainsMono Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.fuse.userAllowOther = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        ioprio = 0;
        inhibit_screensaver = 1;
      };
      cpu = {
        park_cores = 0;
        pin_cores = 0;
      };
    };
  };
  programs.git.enable = true;
  programs.thunar.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    sway
    swaybg
    waybar
    rofi-wayland
    swaylock
    swayidle
    alacritty
    starship
    zsh
    qutebrowser
    neovim
    vim
    fastfetch
    brightnessctl
    git
    pciutils
    wget
    osu-lazer
    appimage-run
    gamemode
    pavucontrol
    grim
    wl-clipboard
  ];

  programs.sway.enable = true;

  system.stateVersion = "26.05";
}
