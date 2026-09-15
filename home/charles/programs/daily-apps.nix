{pkgs, ...}: {
  home.packages = with pkgs; [
    # Cross-device file transfer
    localsend

    # Password manager
    bitwarden-desktop

    # Disk usage analyzer
    baobab
  ];

  # Lightweight keyboard-driven document / PDF reader.
  programs.zathura.enable = true;
}
