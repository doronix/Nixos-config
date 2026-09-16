{ pkgs, ... }:
{
  services.fwupd.enable = true;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "usb-recover" ''
      set -euo pipefail

      controller="0000:08:00.4"
      driver="/sys/bus/pci/drivers/xhci_hcd"

      if [[ ! -e "$driver/$controller" ]]; then
        echo "xHCI controller $controller is not bound."
        exit 1
      fi

      echo "Resetting AMD xHCI controller $controller..."

      echo "$controller" > "$driver/unbind"
      sleep 2
      echo "$controller" > "$driver/bind"

      sleep 2

      echo
      echo "USB controller recovered."
      ${pkgs.usbutils}/bin/lsusb
    '')
  ];
}
