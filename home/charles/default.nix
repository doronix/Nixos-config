{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./shell
    ./programs
    ./terminal
    ./scripts
    ./niri
    ./hyprland
    ./noctalia
    ./fcitx5
    ./rofi
    ./wallpaper
    ./music
  ];

  home.packages = with pkgs; [
    xwayland-satellite # xwayland support
    libnotify
  ];

  # 自动创建截图文件夹
  home.activation.ensureScreenshotDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "${config.home.homeDirectory}/screenshot"
  '';


  # 消息通知
  # Niri 主桌面由 Noctalia 提供通知服务；
  # SwayNC 不作为全局 user service 启动。
  services.swaync.enable = false;
  # Wayland idle / lock / suspend policy
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        # 10 分钟无操作：锁屏
        timeout = 600;
        command = "/etc/profiles/per-user/charles/bin/noctalia msg session lock";
      }
      {
        # 15 分钟无操作：关闭显示器
        timeout = 900;
        command = "/run/current-system/sw/bin/niri msg action power-off-monitors";
      }
      {
        # 45 分钟无操作：系统挂起
        timeout = 2700;
        command = "/run/current-system/sw/bin/systemctl suspend";
      }
    ];

  };

  # services.mako.enable = true;
  # catppuccin.mako = {
  #   enable = true;
  #   accent = "mauve";
  #   flavor = "mocha";
  # };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "image/png" = ["imv.desktop"];
    "image/jpeg" = ["imv.desktop"];
    "image/gif" = ["imv.desktop"];
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "x-scheme-handler/clash" = "clash-verge.desktop";
  };

  # 光标配置
  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8"; # 系统主语言英文
    LC_CTYPE = "zh_CN.UTF-8"; # 字符显示支持中文
    LC_MESSAGES = "en_US.UTF-8"; # 程序输出信息保持英文
  };

  home.stateVersion = "25.11";
  # home.enableNixpkgsReleaseCheck = false;
}
