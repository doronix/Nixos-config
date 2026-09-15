{...}: {
  programs.nh = {
    enable = true;

    # Default flake for `nh os ...`
    flake = "/home/charles/nixos-config-v3";
  };
}
