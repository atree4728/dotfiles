{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  {
    programs.topgrade = {
      enable = true;
      settings = {
        misc = {
          # An allowlist: topgrade also detects the tools that mise and Nix manage.
          only = [
            "brew_formula"
            "brew_cask"
            "mas"
            "rustup"
            "ghcup"
            "elan"
            "juliaup"
            "opam"
            "vim"
            "custom_commands"
          ];
          assume_yes = true;
          pre_sudo = true;
        };
        # The mise step fails on `mise self-update`, which the Nix build of mise rejects.
        commands.mise = "mise upgrade";
        pre_commands."Nix configuration" = "mise -C ${config.dotfiles.dir} run upgrade:nix";
        post_commands = {
          "Garbage collection" = "mise -C ${config.dotfiles.dir} run gc";
          "Lock files" = "mise -C ${config.dotfiles.dir} run lock";
        };
      };
    };
  }
  # nix-installer's Nix is not managed by the flake; on macOS nix-darwin upgrades Nix with it.
  (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    programs.topgrade.settings.pre_commands."Nix" = "sudo -i nix upgrade-nix";
  })
]
