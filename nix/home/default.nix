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
    ./tools.nix
    ./topgrade.nix
  ];

  config = lib.mkMerge [
    {
      xdg.enable = true;

      home.packages = with pkgs; [
        awscli2
        bashInteractive
        cmake
        coreutils-prefixed
        dafny
        dust
        ffmpeg
        ghq
        glow
        gnumake
        hyperfine
        imagemagick
        iverilog
        neovim
        pkgconf
        poppler-utils
        procs
        qemu
        rip2
        (rocq-core.withPackages (ps: [ ps.stdlib ]))
        swi-prolog
        typst
        unison-ucm
        wget
        llm-agents.packages.${stdenv.hostPlatform.system}.claude-code
      ];

      xdg.configFile =
        lib.genAttrs
          [
            "glow"
            "mise/config.toml"
            "nvim"
          ]
          (path: {
            source = link path;
          });

      home.file.".claude/CLAUDE.md".source = link "claude/CLAUDE.md";

      home.stateVersion = "26.11";
    }
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.packages = with pkgs; [
        macism
        mas
        verilator
      ];

      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
        settings = {
          font-family = "PlemolJP35 Console NF";
          font-size = 20;
          font-feature = "-dlig";
          theme = "Catppuccin Macchiato";
          shell-integration = "fish";
          background-opacity = 0.85;
          background-blur-radius = 20;
          macos-titlebar-style = "transparent";
          keybind = "shift+enter=text:\\n";
          macos-window-buttons = "hidden";
          macos-icon = "blueprint";
        };
      };

      xdg.configFile =
        lib.genAttrs
          [
            "aerospace"
            "karabiner"
          ]
          (path: {
            source = link path;
          });
    })
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      targets.genericLinux.enable = true;
    })
  ];
}
