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
