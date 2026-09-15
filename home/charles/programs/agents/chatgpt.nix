{inputs, pkgs, ...}: {
  # OpenAI ChatGPT Desktop for Linux.
  # Package maintained by llm-agents.nix around OpenAI's Linux release.
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
  ];
}
