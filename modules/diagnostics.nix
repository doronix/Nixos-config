{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Storage health / NVMe
    smartmontools
    nvme-cli

    # Process / file diagnostics
    lsof

    # CPU / disk / process statistics
    sysstat

    # Hardware sensors
    lm_sensors

    # Network device diagnostics
    ethtool

    # USB / firmware / hardware inventory
    usbutils
    dmidecode

    # Process tree and related tools
    psmisc
  ];
}
