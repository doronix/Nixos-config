{pkgs, ...}: {
  home.packages = with pkgs; [
    # Network diagnostics
    nmap
    iperf3

    # DNS / Internet
    doggo
    dnsutils
    whois

    # HTTP / HTTPS
    xh
    mitmproxy

    # Network debugging
    socat
    grpcurl
    websocat

    # Structured data
    yq-go
  ];
}
