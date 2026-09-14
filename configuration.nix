{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  nix.settings.trusted-users = ["root" "charles"];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    winetricks
    google-chrome
    pulseaudio
    pciutils # lspci
    ffmpeg
    libva
    libva-utils
    power-profiles-daemon
    vim
    git
    curl
    wget
    bluez
    cachix
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "kitty";
    # GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    QT5_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  programs.steam.enable = true;
  programs.steam.fontPackages = with pkgs; [source-han-sans];
  programs.zsh.enable = true;
  users.users.charles = {
    description = "Charles";
    isNormalUser = true;
    home = "/home/charles";
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = ["wheel" "networkmanager" "audio" "input" "video" "docker" "kvm" "libvirtd"];
  };

  # Keep the proven R9000P boot baseline for the first v3 migration.
  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;

    loader = {
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };

      efi.canTouchEfiVariables = true;
    };

    # Keep the existing AHCI power-management workaround.
    kernelParams = [ "ahci.mobile_lpm_policy=1" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.timesyncd.enable = true;

  # U盘自动加载
  services.udisks2.enable = true;

  # networking
  networking.hostName = "r9000p";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    5900
  ];

  # 禁用所有形式的睡眠和休眠
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes"; # 如果只想禁用休眠，可以保持 Suspend 启用
    AllowHibernation = "no"; # 禁用休眠 (Hibernate)
    AllowHybridSleep = "no"; # 禁用混合睡眠 (Hybrid Sleep)
    AllowSuspendThenHibernate = "no"; # 禁用先睡眠后休眠
  };

  # timezone and local
  time.timeZone = "Asia/Shanghai";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_CTYPE = "zh_CN.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    dejavu_fonts

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Sans" "Noto Sans CJK SC"];
        sansSerif = ["Noto Serif" "Noto Serif CJK SC"];
        monospace = ["Fira Code"];
      };
    };
  };

  programs.xwayland.enable = true;

  # Niri
  programs.niri.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  # Login: keep the proven greetd -> tuigreet -> niri-session chain
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "env LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US:en ${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --cmd niri-session";
      user = "greeter";
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # services.displayManager.sddm.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Enable sound.
  services.pulseaudio.enable = false;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  hardware = {
    enableAllFirmware = true; # 自动安装所有固件
    cpu.amd.updateMicrocode = true; # AMD CPU
  };

  # Graphics: AMD iGPU + RTX 4060 Laptop
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD iGPU 负责日常桌面，RTX 4060 按需 PRIME Offload
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # RTX 4060 (Ada) 使用 NVIDIA Open Kernel Module
    open = true;
    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    prime = {
      amdgpuBusId = "PCI:8:0:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  system.stateVersion = "26.05";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


}
