{pkgs, ...}: {
  home.packages = with pkgs; [
    # Development / productivity
    dbeaver-bin
    bruno
    drawio
    libreoffice
    kdePackages.okular
    kdePackages.kate
    kdiskmark

    # Cross-device file transfer
    localsend

    # Password manager
    bitwarden-desktop

    # Disk usage analyzer
    baobab

    # Dolphin archive integration
    kdePackages.ark

    # Wayland utilities
    wl-mirror
    hyprpicker
    udiskie
  ];


  # Default application for plain-text files.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "org.kde.kate.desktop" ];
    };
  };

  programs.zathura.enable = true;

  # Auto-mount USB drives / removable storage.
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };
}
