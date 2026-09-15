{pkgs-unstable, ...}: {
  # OpenCode：备用，当前不要求登录。
  home.packages = [
    pkgs-unstable.opencode
  ];
}
