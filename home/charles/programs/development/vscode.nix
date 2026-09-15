{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;

    # 保留 VSCode 内手动安装扩展的能力
    mutableExtensionsDir = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Python / AI
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        charliermarsh.ruff
        ms-toolsai.jupyter

        # Web / TS
        esbenp.prettier-vscode

        # Git
        eamodio.gitlens

        # Docker / Remote
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers

        # NixOS
        jnoortheen.nix-ide
      ];

      userSettings = {
        # Python
        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;

        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll.ruff" = "explicit";
            "source.organizeImports.ruff" = "explicit";
          };
        };

        # JS / TS / JSON
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

        "[javascript]"."editor.formatOnSave" = true;
        "[typescript]"."editor.formatOnSave" = true;
        "[json]"."editor.formatOnSave" = true;
        "[jsonc]"."editor.formatOnSave" = true;
      };
    };
  };
}
