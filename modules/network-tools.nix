{pkgs, ...}: {
  # mtr needs raw socket capability for normal-user diagnostics.
  programs.mtr.enable = true;

  # Wireshark GUI + privileged dumpcap wrapper.
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;

    # Allow wireshark-group users to capture normal network traffic.
    dumpcap.enable = true;

    # We do not need raw USB capture for now.
    usbmon.enable = false;
  };

  users.users.charles.extraGroups = [
    "wireshark"
  ];
}
