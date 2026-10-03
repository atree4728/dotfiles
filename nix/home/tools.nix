{
  lib,
  pkgs,
  llm-agents,
  ...
}:
lib.mkMerge [
  {
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

    programs.bat.enable = true;
    programs.bottom.enable = true;
    programs.fastfetch.enable = true;
    programs.fd.enable = true;
    programs.htop.enable = true;
    programs.jq.enable = true;
    programs.ripgrep.enable = true;
    programs.tealdeer.enable = true;

    programs.lsd = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.lazygit = {
      enable = true;
      settings.git.diffRenderers = [ { command = "delta --dark --paging=never"; } ];
    };

    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  }
  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.packages = with pkgs; [
      macism
      mas
      verilator
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      # OrbStack requires its Include to precede every Host block.
      includes = [ "~/.orbstack/ssh/config" ];
      settings."*".IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
    };
  })
]
