{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "8roots";
        email = "8roots@proton.me";
      };

      init.defaultBranch = "main";

      # 当前网络环境下 GitHub Git 流量显式经过 Clash。
      # 不设置全局 http.proxy，避免影响其他 Git 服务。
      http."https://github.com/".proxy = "http://127.0.0.1:7897";
      http."https://gist.github.com/".proxy = "http://127.0.0.1:7897";
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "https";
    };
  };
}
