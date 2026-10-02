{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}:
let
  repo = "${config.home.homeDirectory}/src/github.com/atree4728/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.packages = with pkgs; [
    awscli2
    bashInteractive
    bat
    bottom
    coreutils-prefixed
    dafny
    dust
    eza
    fastfetch
    fd
    ffmpeg
    fzf
    ghq
    glow
    htop
    hyperfine
    imagemagick
    iverilog
    jq
    lazygit
    mise
    neovim
    poppler-utils
    procs
    qemu
    rip2
    ripgrep
    (rocq-core.withPackages (ps: [ ps.stdlib ]))
    starship
    swi-prolog
    tealdeer
    typst
    verilator
    wget
    yazi
    zoxide
    llm-agents.packages.${stdenv.hostPlatform.system}.claude-code
  ];

  xdg.configFile =
    lib.genAttrs
      [
        "aerospace"
        "ghostty"
        "glow"
        "karabiner"
        "lazygit"
        "mise/config.toml"
        "nvim"
        "starship.toml"
      ]
      (path: {
        source = link path;
      });

  home.file = {
    ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
    "Library/Application Support/Code/User/keybindings.json".source = link "vscode/keybindings.json";
    "Library/Application Support/Code/User/settings.json".source = link "vscode/settings.json";
  };

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
      aliases.co = "pr checkout";
    };
  };

  home.stateVersion = "26.11";
}
