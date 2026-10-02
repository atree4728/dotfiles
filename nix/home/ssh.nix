{ lib, pkgs, ... }:
{
  programs.ssh = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    enableDefaultConfig = false;
    # OrbStack requires its Include to precede every Host block.
    includes = [ "~/.orbstack/ssh/config" ];
    settings."*".IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
  };
}
