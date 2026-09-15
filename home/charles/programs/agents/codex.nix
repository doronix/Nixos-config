{pkgs-unstable, ...}: {
  # OpenAI Codex CLI
  home.packages = [
    pkgs-unstable.codex
  ];
}
