{pkgs, ...}: {
  home.packages = with pkgs; [
    # Network diagnostics
    nmap
    iperf3

    # DNS
    doggo

    # HTTP / HTTPS
    xh
    mitmproxy
  ];
}
