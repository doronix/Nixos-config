{pkgs-unstable, ...}: {
  # Claude Code：备用，当前不要求登录。
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
  };
}
