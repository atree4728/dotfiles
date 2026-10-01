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
    delta
    dust
    eza
    fastfetch
    fd
    ffmpeg
    fzf
    gh
    ghq
    git
    glow
    htop
    hyperfine
    imagemagick
    iverilog
    jq
    lazygit
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

  home.stateVersion = "26.11";
}
