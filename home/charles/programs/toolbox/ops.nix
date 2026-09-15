{pkgs, ...}: {
  home.packages = with pkgs; [
    # Containers
    lazydocker
    dive
    skopeo
    go-containerregistry

    # Git / security
    gitleaks

    # Database
    pgcli

    # Benchmark / system utilities
    hyperfine
    duf
    dust
    procs

    # Developer workflow
    just
    watchexec
    sd
  ];
}
