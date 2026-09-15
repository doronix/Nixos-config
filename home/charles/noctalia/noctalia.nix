_: {
  programs.noctalia = {
    enable = true;

    # 由 Niri spawn-at-startup 启动，避免重复实例。
    systemd.enable = false;
  };

  # Noctalia 原生壁纸库。
  home.file.".config/noctalia/wallpaper.toml".text = ''
    [wallpaper]
    enabled = true
    directory = "/home/charles/.config/wallpaper"
  '';

  # Noctalia 原生 PolicyKit 认证 Agent。
  home.file.".config/noctalia/shell.toml".text = ''
    [shell]
    polkit_agent = true
  '';
}
