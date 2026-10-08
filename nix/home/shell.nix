{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  homeDir = config.home.homeDirectory;
  nixPath = [
    "${config.home.profileDirectory}/bin"
  ]
  ++ lib.optional isDarwin "/run/current-system/sw/bin"
  ++ [ "/nix/var/nix/profiles/default/bin" ];
in
lib.mkMerge [
  {
    home.sessionPath = [
      "${homeDir}/.local/bin"
      "${homeDir}/.cargo/bin"
      "${homeDir}/.ghcup/bin"
      "${homeDir}/.cabal/bin"
      "${homeDir}/.elan/bin"
      "${homeDir}/.juliaup/bin"
      "${homeDir}/.dotnet/tools"
    ];

    home.sessionVariables.EDITOR = "nvim";

    programs.fish = {
      enable = true;
      loginShellInit = ''
        fish_add_path --global --move --path ${toString nixPath}
        fish_add_path --global --move --path ${toString config.home.sessionPath}
      '';
      shellAbbrs = {
        cat = "bat";
        restart = "exec $SHELL -l";
      };
      functions.ghq_cd = ''
        set repo (ghq list --full-path | fzf --query=(commandline --current-buffer))
        and cd -- $repo
        commandline --function repaint
      '';
      binds."ctrl-g".command = "ghq_cd";
      plugins = [
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];
    };

    programs.zsh.enable = true;

    # opam 2.6 migrates ~/.opam irreversibly; drop the override once nixpkgs ships 2.6.0 (NixOS/nixpkgs#564221).
    programs.opam = {
      enable = true;
      package = pkgs.opam.overrideAttrs (
        finalAttrs: _: {
          version = "2.6.0";
          src = pkgs.fetchurl {
            url = "https://github.com/ocaml/opam/releases/download/${finalAttrs.version}/opam-full-${finalAttrs.version}.tar.gz";
            hash = "sha256-66c2AlP9eR657aq+SEjqDFmzXaX19duq/162i/YYygg=";
          };
        }
      );
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.fzf = {
      enable = true;
      enableFishIntegration = false;
    };
    programs.mise.enable = true;
    programs.starship = {
      enable = true;
      settings = {
        aws.disabled = true;
        gcloud.disabled = true;
      };
    };
    programs.zoxide.enable = true;
  }
  (lib.mkIf isDarwin {
    home.sessionPath = [
      "/opt/oss-cad-suite/bin"
      "/opt/homebrew/opt/llvm/bin"
      "${homeDir}/.orbstack/bin"
    ];

    programs.fish.loginShellInit = lib.mkBefore ''
      fish_add_path --global --append --path (/usr/libexec/path_helper -s | string match --regex --groups-only '^PATH="(.*)";' | string split :)
    '';
  })
  (lib.mkIf isLinux {
    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $(ps --no-header --pid=$PPID --format=comm) != fish && -z $BASH_EXECUTION_STRING ]]; then
          exec fish -l
        fi
      '';
    };
  })
]
