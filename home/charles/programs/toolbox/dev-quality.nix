{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shell quality
    shellcheck
    shfmt

    # CI / GitHub Actions
    actionlint

    # Performance / project inspection
    k6
    tokei

    # Media utility
    yt-dlp
  ];

  # Persistent, searchable shell history.
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    # Keep normal Up-arrow history behavior.
    # Atuin only takes over Ctrl-R.
    flags = [
      "--disable-up-arrow"
    ];
  };
}
