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
  imports = [
    ./git.nix
    ./shell.nix
    ./ssh.nix
    ./topgrade.nix
  ];

  config = lib.mkMerge [
    {
      xdg.enable = true;

      home.packages = with pkgs; [
        awscli2
        bashInteractive
        bat
        bottom
        cmake
        coreutils-prefixed
        dafny
        dust
        eza
        fastfetch
        fd
        ffmpeg
        ghq
        glow
        gnumake
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
            "glow"
            "lazygit"
            "mise/config.toml"
            "nvim"
            "starship.toml"
          ]
          (path: {
            source = link path;
          });

      home.file.".claude/CLAUDE.md".source = link "claude/CLAUDE.md";

      home.stateVersion = "26.11";
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.packages = [ pkgs.mas ];

      xdg.configFile =
        lib.genAttrs
          [
            "aerospace"
            "ghostty"
            "karabiner"
          ]
          (path: {
            source = link path;
          });
    })
  ];
}
