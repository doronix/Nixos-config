{pkgs, ...}: {
  # Android <-> NixOS integration:
  # file transfer, clipboard, notifications, remote control, etc.
  programs.kdeconnect.enable = true;

  # KDE applications such as Dolphin rely on an XDG applications.menu.
  # Niri does not provide one, so create a minimal Freedesktop menu that
  # exposes all installed .desktop applications to KService.
  environment.systemPackages = [
    (pkgs.writeTextFile {
      name = "minimal-applications-menu";
      destination = "/etc/xdg/menus/applications.menu";
      text = ''
        <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
          "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">

        <Menu>
          <Name>Applications</Name>

          <DefaultAppDirs/>
          <DefaultDirectoryDirs/>

          <Include>
            <All/>
          </Include>

          <DefaultLayout>
            <Merge type="menus"/>
            <Merge type="files"/>
          </DefaultLayout>

          <DefaultMergeDirs/>
        </Menu>
      '';
    })
  ];
}
