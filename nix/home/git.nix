{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "atree4728";
        email = "atree.public@gmail.com";
      };
      init.defaultBranch = "main";
      core.pager = "delta";
      merge.conflictStyle = "zdiff3";
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      fetch.prune = true;
      pull.ff = "only";
      push.autoSetupRemote = true;
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere.enabled = true;
      branch.sort = "-committerdate";
      commit.verbose = true;
      ghq.root = "~/src";
    };
    ignores = [
      ".DS_Store"
      ".idea"
      ".vscode"
      "**/.claude/settings.local.json"
      "**/CLAUDE.local.md"
      "mise.local.toml"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.navigate = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };
}
