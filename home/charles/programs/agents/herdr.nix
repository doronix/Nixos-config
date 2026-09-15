{inputs, pkgs, ...}: let
  herdrPackage =
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;

  toml = pkgs.formats.toml {};

  herdrConfig = {
    onboarding = false;

    # Herdr 由 Nix 管理版本，不让应用自己更新。
    update = {
      version_check = false;
      manifest_check = false;
    };

    # ~/.ssh/config 由我们自己的配置管理。
    remote.manage_ssh_config = false;

    theme.name = "catppuccin";

    terminal = {
      default_shell = "${pkgs.zsh}/bin/zsh";
      shell_mode = "auto";
      new_cwd = "follow";
    };

    ui = {
      agent_panel_sort = "priority";
      prompt_new_tab_name = false;

      sound.enabled = false;
    };

    session.resume_agents_on_restore = true;

    experimental.kitty_graphics = true;
  };
in {
  home.packages = [
    herdrPackage
  ];

  xdg.configFile."herdr/config.toml".source =
    toml.generate "herdr-config.toml" herdrConfig;
}
