{pkgs, ...}: {
  home.packages = with pkgs; [
    # Database CLI
    sqlite
    postgresql_17
    redis

    # Documentation / diagrams
    pandoc
    graphviz

    # Android debugging
    android-tools
    scrcpy

    # Crypto / certificates
    openssl
    gnupg
  ];
}
