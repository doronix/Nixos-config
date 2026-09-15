{pkgs, ...}: {
  home.packages = with pkgs; [
    # Containers
    lazydocker
    dive

    # Git / security
    gitleaks

    # Database
    pgcli

    # Benchmark / system utilities
    hyperfine
    duf
  ];
}
