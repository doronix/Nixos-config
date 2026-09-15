{ ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "8roots";
        email = "8roots@proton.me";
      };

      init.defaultBranch = "main";

      # Show the common ancestor in merge conflicts.
      merge.conflictStyle = "zdiff3";

      # Usually produces cleaner diffs when code blocks move around.
      diff.algorithm = "histogram";

      # Remove stale remote-tracking branches during fetch.
      fetch.prune = true;

      # Current network environment: only GitHub traffic goes through Clash.
      # Do not set a global http.proxy, so other Git services remain unaffected.
      http."https://github.com/".proxy = "http://127.0.0.1:7897";
      http."https://gist.github.com/".proxy = "http://127.0.0.1:7897";
    };
  };

  # Better Git diff / log / show output.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      line-numbers = true;
      navigate = true;
      hyperlinks = true;
      side-by-side = false;
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "https";
    };
  };
}
