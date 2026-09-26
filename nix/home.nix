{ pkgs, ... }:
{
  home.packages = [ pkgs.hello ];

  home.stateVersion = "26.11";
}
