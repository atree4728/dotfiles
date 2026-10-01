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
        "aerospace"
        "ghostty"
        "glow"
        "karabiner"
        "lazygit"
        "mise/config.toml"
        "nvim"
        "starship.toml"
      ]
      (path: {
        source = link path;
      });

  home.file =
    lib.genAttrs
      [
        "keybindings.json"
        "settings.json"
      ]
      (file: {
        target = "Library/Application Support/Code/User/${file}";
        source = link "vscode/${file}";
      });

  home.stateVersion = "26.11";
}
