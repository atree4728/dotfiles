{
  config,
  lib,
  pkgs,
  ...
}:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.dir}/config/${path}";
in
{
  imports = [
    ./ghostty.nix
    ./git.nix
    ./shell.nix
    ./tools.nix
    ./topgrade.nix
  ];

  options.dotfiles.dir = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/src/github.com/atree4728/dotfiles";
    description = "Absolute path of the working tree of this repository; `config/` is symlinked from it.";
  };

  config = lib.mkMerge [
    {
      xdg.enable = true;

      # Building the man page trips the "options.json ... without a proper context" warning.
      manual.manpages.enable = false;

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

      # The installer does not enable flakes.
      nix = {
        package = pkgs.nix;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    })
  ];
}
