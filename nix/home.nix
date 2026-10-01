{
  config,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/src/github.com/atree4728/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/config/${path}";
in
{
  home.packages = [ pkgs.hello ];

  xdg.configFile =
    lib.genAttrs
      [
        "glow"
        "lazygit"
      ]
      (path: {
        source = link path;
      });

  home.stateVersion = "26.11";
}
