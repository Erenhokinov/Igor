{
  config,
  pkgs,
  lib,
  ...
}: 
let
  oldNixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/heads/release-21.05.tar.gz";
  }) { system = "x86_64-linux"; config.allowUnfree = true; };
in {

  imports = [./hardware-configuration.nix];

  boot.loader.grub.device = "/dev/sda";

  boot.kernelPackages = pkgs.linuxPackages_6_1;

  boot.kernelParams = [
    "mitigations=off"
    "nowatchdog"
    "processor.max_cstate=1"
    "noibrs"
    "noibpb"
    "nopti"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
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
  services.flatpak.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "none+i3";
services.xserver = {
  enable = true;
  windowManager.i3.enable = true;
  xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };
  videoDrivers = ["nvidia"];
  deviceSection = ''
    BusID "PCI:2:0:0"
  '';
  serverFlagsSection = ''
    Option "IgnoreABI" "1"
  '';
  modules = lib.mkBefore [ config.hardware.nvidia.package.bin ];
};

hardware.nvidia = {
  modesetting.enable = false;
  open = false;
  nvidiaSettings = false;
  package = (config.boot.kernelPackages.nvidiaPackages.legacy_340.override {
    stdenv = pkgs.gcc13Stdenv;
  }).overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      ln -sf libglx.so.340.108 $bin/lib/xorg/modules/extensions/libglx.so
    '';
  });
};
  powerManagement.cpuFreqGovernor = "performance";

  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = false;
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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "16";
    LD_PRELOAD = "";
  };

  users.users."maks" = {
    isNormalUser = true;
    description = "maks";
    shell = pkgs.zsh;
    initialPassword = "Eren228228";
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
  nixpkgs.config.nvidia.acceptLicense = true;

  environment.systemPackages = with pkgs; [
    alacritty
    starship
    zsh
    brave
    neovim
    vim
    materialgram
    legcord
    fastfetch
     xclip
    maim
    i3blocks
    xorg.xsetroot
    picom
    polybar
    xwallpaper
    brightnessctl
    git
    rofi
    pciutils
    wget
    osu-lazer-bin
    appimage-run
    gamemode
    pavucontrol
  ];

  system.stateVersion = "25.05";
}
