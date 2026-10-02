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
  homeDir = config.home.homeDirectory;
  nixPath = [
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
  ];
in
{
  home.sessionPath = [
    "${homeDir}/.local/bin"
    "${homeDir}/.cargo/bin"
    "${homeDir}/.ghcup/bin"
    "${homeDir}/.cabal/bin"
    "${homeDir}/.elan/bin"
    "${homeDir}/.juliaup/bin"
    "${homeDir}/.dotnet/tools"
    "/opt/oss-cad-suite/bin"
    "/opt/homebrew/opt/llvm/bin"
    "/Applications/Ghostty.app/Contents/MacOS"
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.enable = true;

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
    ghq
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
    swi-prolog
    tealdeer
    typst
    verilator
    wget
    yazi
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

  programs.fish = {
    enable = true;
    loginShellInit = ''
      fish_add_path --global --append --path (/usr/libexec/path_helper -s | string match --regex --groups-only '^PATH="(.*)";' | string split :)
      /opt/homebrew/bin/brew shellenv fish | source
      fish_add_path --global --move --path ${toString nixPath}
      fish_add_path --global --move --path ${toString config.home.sessionPath}
      fish_add_path --global --move --append --path ${homeDir}/.orbstack/bin
      source ${homeDir}/.opam/opam-init/init.fish &>/dev/null
    '';
    shellAbbrs = {
      ls = "eza --all --icons auto";
      cat = "bat";
      restart = "exec $SHELL -l";
    };
    functions.y = ''
      set tmp (mktemp -t "yazi-cwd.XXXXXX")
      command yazi $argv --cwd-file="$tmp"
      if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
      end
      command rm -f -- "$tmp"
    '';
    plugins = [
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "fish-ghq";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-ghq";
          rev = "cafaaabe63c124bf0714f89ec715cfe9ece87fa2";
          hash = "sha256-6b1zmjtemNLNPx4qsXtm27AbtjwIZWkzJAo21/aVZzM=";
        };
      }
    ];
  };

  programs.fzf = {
    enable = true;
    # fzf.fish binds the same keys.
    enableFishIntegration = false;
  };
  programs.mise.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

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

  home.stateVersion = "26.11";
}
