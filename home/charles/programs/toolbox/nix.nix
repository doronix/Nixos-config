{pkgs, ...}: {
  home.packages = with pkgs; [
    # Nix UX
    nix-output-monitor
    nix-index
    nix-tree
    nix-melt
    nix-init
    nvd

    # Nix development
    nixd
    nixfmt
    statix
    deadnix
  ];
}
