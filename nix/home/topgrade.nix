{ config, ... }:
let
  repo = "${config.home.homeDirectory}/src/github.com/atree4728/dotfiles";
in
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
      pre_commands = {
        "Determinate Nix" = "sudo determinate-nixd upgrade";
        "Nix configuration" = "mise -C ${repo} run upgrade:nix";
      };
      post_commands = {
        "Garbage collection" = "mise -C ${repo} run gc";
        "Lock files" = "mise -C ${repo} run lock";
      };
    };
  };
}
