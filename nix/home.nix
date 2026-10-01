{
  config,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/src/github.com/atree4728/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.packages = with pkgs; [
    bashInteractive
    bat
    bottom
    coreutils-prefixed
    dust
    eza
    fastfetch
    fd
    fzf
    glow
    htop
    hyperfine
    jq
    procs
    ripgrep
    starship
    tealdeer
    wget
    yazi
    zoxide
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
