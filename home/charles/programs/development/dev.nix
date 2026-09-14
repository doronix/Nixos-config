{pkgs, ...}: {
  home.packages = with pkgs; [
    typst

    nodejs_24
    pnpm_10

    # rustup
    rustc
    cargo
    rustfmt

    go

    python313
    uv

    gcc15
    gdb
    pkg-config
    cmake
    gnumake
    ninja
  ];
}
